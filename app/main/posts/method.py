from datetime import datetime
from sqlalchemy import func

from config import MAX_COMPLAINT_SUM
from config import GAME_CIRCLE_IP
from config import GAME_CIRCLE_PORT

from ...models import MSGKEYVAL
from ...models import MESSAGELIST
from ...models import MESSAGEPIC
from ...models import USERS
from ...models import USER_SCORE_LOG
from ...models import KEYADAPTER_COUNT
from ...models import MEDALLIST
from ...models import USER_MEDAL
from .. import util
from ...models import db
from ... import logger

FIRST_LEVEL = 1
SECOND_LEVEL = 2
THIRD_LEVEL = 3
ADD_FACTOR_LEVEL1 = 0x0000000100000000
ADD_FACTOR_LEVEL2 = 0x0000000000010000
ADD_FACTOR_LEVEL3 = 0x0000000000000001
HASH_DB_ERROR = 0
LEVEL1MAX = 0xFFFFFFFF00000000
LEVEL2MAX = 0x00000000FFFF0000
LEVEL3MAX = 0x000000000000FFFF

def LEVEL1MASK(SpecLevelNo):
    return SpecLevelNo & 0xFFFFFFFF00000000
def LEVEL2MASK(SpecLevelNo):
    return SpecLevelNo & 0x00000000FFFF0000
def LEVEL3MASK(SpecLevelNo):
    return SpecLevelNo & 0x000000000000FFFF


def MaxLevelNo_GetWhichLevel(SpecLevelNo):
    '''
    brief 根据指定的贴序号，分析要获取哪层的level
    Input param llSpecLevelNo 需要分析的levelno
    return level1 或者level2 或者level3 或者报错

    note 支持多线程。 举例：
    输入 0000000000000000   返回 0000000100000000
    输入 0000000100000000   返回 0000000100010000
    输入 0000000100010000   返回 0000000100010001
    :param SpecLevelNo:
    :return:
    '''
    if LEVEL1MASK(SpecLevelNo) > 0:
        if LEVEL2MASK(SpecLevelNo) > 0:
            return THIRD_LEVEL
        else:
            return SECOND_LEVEL
    else:
        return FIRST_LEVEL


def getKeyValue(SpecLevelNo):
    OutKeyValue = MSGKEYVAL.query.filter_by(MSGKEY=SpecLevelNo).with_entities(MSGKEYVAL.MSGVALUE).first()
    if OutKeyValue is None:
        return util.no_data().get('CODE'), 0
    return 100, OutKeyValue[0]


def insert_key(SpecLevelKey):
    msg_key = MSGKEYVAL(MSGKEY=SpecLevelKey, MSGKEYVAL=SpecLevelKey)
    db.session.add(msg_key)
    db.session.commit()
    return 100


def updKeyValue(SpecLevelKey, OutLevelNo):
    msg_key = MSGKEYVAL.query.filter_by(MSGKEY=SpecLevelKey).first()
    msg_key.MSGVALUE = OutLevelNo
    db.session.add(msg_key)
    db.session.commit()
    return 100


HDB_LEVEL_FULL = 103


def GETLEVEL1(SpecLevelNo):
    return SpecLevelNo & 0x0000000000000000


def GETLEVEL2(SpecLevelNo):
    return SpecLevelNo & 0xFFFFFFFF00000000


def GETLEVEL3(SpecLevelNo):
    return SpecLevelNo & 0xFFFFFFFFFFFF0000


def MaxLevelNo_GetRecordNo_SQL(SpecLevelNo):
    # 查询发帖层次，计算帖子ID
    eWhichLevel = MaxLevelNo_GetWhichLevel(SpecLevelNo)
    if eWhichLevel == FIRST_LEVEL:
        SpecLevelKey = GETLEVEL1(SpecLevelNo)
        AddFactorLevel = ADD_FACTOR_LEVEL1
    elif eWhichLevel == SECOND_LEVEL:
        SpecLevelKey = GETLEVEL2(SpecLevelNo)
        AddFactorLevel = ADD_FACTOR_LEVEL2
    elif eWhichLevel == THIRD_LEVEL:
        SpecLevelKey = GETLEVEL3(SpecLevelNo)
        AddFactorLevel = ADD_FACTOR_LEVEL3
    else:
        return HASH_DB_ERROR

    # 查询计算出来的帖子ID是否存在，不存在则插入#
    logger.debug(SpecLevelNo)
    ret, result = getKeyValue(SpecLevelNo)
    logger.debug(ret)
    logger.debug('%#x' % result)
    if ret == util.no_data().get('code'):
        OutLevelNo = SpecLevelKey
        ret = insert_key(SpecLevelKey)
        if ret != 100:
            return ret
    elif ret == 100:
        OutLevelNo = result
    else:
        return ret
    # 判断帖子ID值是否超出正常值，超出则返回错误
    if FIRST_LEVEL == eWhichLevel:
        if LEVEL1MASK(OutLevelNo) >= LEVEL1MAX:
            ret = HDB_LEVEL_FULL
    elif SECOND_LEVEL == eWhichLevel:
        if LEVEL2MASK(OutLevelNo) >= LEVEL2MAX:
            ret = HDB_LEVEL_FULL
    else:
        if LEVEL3MASK(OutLevelNo) >= LEVEL3MAX:
            ret = HDB_LEVEL_FULL
    
    if ret == HDB_LEVEL_FULL:
        return ret

    # 更新帖子ID范围值
    OutLevelNo = OutLevelNo + AddFactorLevel
    ret = updKeyValue(SpecLevelKey, OutLevelNo)
    if 100 != ret:
        logger.error("updKeyValue [key:0x%01611x, value:0x%0x1611x] failed, ret = %d" % (
            SpecLevelKey, OutLevelNo, ret
        ))
    return ret, OutLevelNo


def LEVEL1VALUE(ID):
    return (ID & 0xFFFFFFFF00000000) >> 32


def LEVEL2VALUE(ID):
    return (ID & 0x00000000FFFF0000) >> 16


def LEVEL3VALUE(ID):
    return ID & 0x000000000000FFFF


def insertMessagelist(out_id, sn, to_name, title, content, has_game, game_name,
                      has_adapter, hashcode, pic_len, reply_id=0,
                      FromSN='', ToSN=''):
    Level1ID = LEVEL1VALUE(out_id)
    Level2ID = LEVEL2VALUE(out_id)
    Level3ID = LEVEL3VALUE(out_id)
    if to_name != '0' and len(to_name) != 0:
        reply_sn = USERS.query.filter_by(ACCOUNTNAME=to_name).with_entities(
            USERS.DEVICE_SN
        ).first()
    elif Level1ID != 0 and reply_id != 0:
        reply_sn = MESSAGELIST.query.filter_by(MSGKEY=reply_id).with_entities(
            MESSAGELIST.DEVICE_SN
        ).first()
    else:
        reply_sn = ''
    
    if reply_sn is None:
        return util.bad_content()
    elif len(reply_sn) != 0:
        reply_sn = reply_sn[0]
    
    msg_list = MESSAGELIST(MSGKEY=out_id, DEVICE_SN=sn, TITLE=title,
                           MASSAGE=content, LEVEL1ID=Level1ID,
                           LEVEL2ID=Level2ID, LEVEL3ID=Level3ID,
                           CREATED_DATE=datetime.now(), MODIFIED_DATE=datetime.now(),
                           REPLY_NAME=to_name, HASGAME=has_game, APP_NAME=game_name,
                           HASADAPTER=has_adapter, ADAPTER_HASHCODE=hashcode,
                           PICNUM=pic_len, ADMIRECOUNT=0, VISCOUNT=0, COMPLAINNUM=0,
                           REPLYNUM=0, ISREAD=0, PRI_ORI_SN=FromSN, PRI_DES_SN=ToSN,
                           REPLY_SN=reply_sn, REPLYKEY=reply_id)
    db.session.add(msg_list)
    db.session.commit()
    return 100


def insertMessagePic(msg_key, pic_list, pic_len):
    try:
        pic_dic = dict(MSGKEY=msg_key)
        for i in range(1, pic_len + 1):
            pic_dic['PIC' + str(i)] = pic_list[i - 1]
        msg_pic = MESSAGEPIC(**pic_dic)
        db.session.add(msg_pic)
        db.session.commit()
        return 100
    except:
        return util.server_db_busy().get('code')


def checkKeyIsExist(msg_key):
    msg_key = MESSAGELIST.query.filter_by(MSGKEY=msg_key).with_entities(MESSAGELIST.MSGKEY).first()
    if msg_key is None:
        return util.no_data().get('CODE')
    else:
        return 100


def updateMessagePic(msg_key, pic_list, pic_len):
    msg_pic = MESSAGEPIC.query.filter_by(MSGKEY=msg_key).first()
    pic_dic = {}
    for i in range(1, pic_len + 1):
        pic_dic['PIC' + str(i)] = pic_list[i - 1]
    msg_pic.__dict__ = dict(msg_pic.__dict__, **pic_dic)
    db.session.add(msg_pic)
    db.session.commit()
    return 100


def updateMessagelist(msg_key, sn, reply_name, title, content, has_game, game_name, has_adapter,
                      hashcode, picture_count):
    msg_list = MESSAGELIST.query.filter_by(MSGKEY=msg_key, DEVICE_SN=sn).first()
    msg_list.TITLE = title
    msg_list.MASSAGE = content
    msg_list.REPLY_NAME = reply_name
    msg_list.HASGAME = has_game
    msg_list.APP_NAME = game_name
    msg_list.HASADAPTER = has_adapter
    msg_list.HASHCODE = hashcode
    msg_list.PICNUM = picture_count
    msg_list.MODIFIED_DATE = datetime.now()
    db.session.add(msg_list)
    db.session.commit()
    return 100


def getAdapterDownLoadCount(hashcode):
    adapter = KEYADAPTER_COUNT.query.filter_by(ADAPTER_HASHCODE=hashcode)
    return adapter


def getUserScore(Account):
    user_score = USER_SCORE_LOG.query.filter_by(DEVICE_SN=Account).with_entities(func.sum(USER_SCORE_LOG.SCORE)).first()
    if user_score is None:
        return 0
    else:
        user_score = user_score[0]
        return user_score


def getMedal(medal_id, account):
    user_medal = USER_MEDAL.query.filter_by(DEVICE_SN=account, MEDALID=medal_id).first()
    return user_medal

def concat_url(filename, path=None):
    if path:
        pathname = path + '/' + filename
    else:
        pathname = filename
    return 'http://' + GAME_CIRCLE_IP + ':' + GAME_CIRCLE_PORT + '/' + pathname

def getMedalList(account, isOnlyOwn):
    medal_list = MEDALLIST.query.all()
    user_medal_list =  list()
    for medal in medal_list:
        user_medal = getMedal(account, medal.MEDALID)
        if user_medal:
            isDisplay = user_medal.DISPLAY
            #判断用户勋章是否过期
            if user_medal.OVER_DATE < datetime.now():
                isOwn = 1
            else:
                isOwn = 0
            
        else:
            isDisplay = 0
            isOwn = 0
        
        if isOnlyOwn and (isDisplay or isOwn):
            continue
        
        if isOwn:
            pic = medal.HAVE_MEDALICON
        else:
            pic = medal.NO_MEDALICON
        
        medal_info = dict()
        medal_info['NAME'] = medal.MEDALNAME
        medal_info['ICON'] = concat_url(pic)
        
        if isOnlyOwn:
            user_medal_list.append(medal_info)
            continue
        
        medal_info['DESCRIPTION'] = medal.DESCR
        
        GetTime = user_medal.GET_DATE
        if GetTime:
            GetTime = GetTime.timestamp()
        else:
            GetTime = 0
        #获取时间
        medal_info['TIME'] = GetTime
        #是否拥有该勋章
        medal_info['ISOWN'] = isOwn
        #有效期 按天计算
        medal_info['DEADLINE'] = str(medal.DEADLINE) + '天'
        #如果勋章使用期限到了，自动把ISUSE,ISOWN 变成0，表示勋章过期了
        #此功能应放到每天运行一次的脚本处理
        medal_info['ISUSE'] = isDisplay
        
        user_medal_list.append(medal_info)
    return user_medal_list


def getDetailTopic1(msg_key):
    try:
        msg_list = MESSAGELIST.query.filter_by(MSGKEY=msg_key).with_entities(
            MESSAGELIST.TITLE, MESSAGELIST.MASSAGE, MESSAGELIST.COMPLAINNUM,
            MESSAGELIST.CREATED_DATE, MESSAGELIST.VISCOUNT,
            MESSAGELIST.REPLYNUM
        ).first()
        if msg_list is None:
            return {}
        
        complaint_num = msg_list.COMPLAINNUM
        if complaint_num >= MAX_COMPLAINT_SUM:
            return {}
        
        info = dict()
        # 因投诉被封，0就是没有被封，这里暂定为0，被封帖不能查看
        info['CLOSED_BYCOMPLAINT'] = 0
        # 投诉次数，终端会根据此值提醒用户
        info['COMPLAINNUM'] = complaint_num
        # 帖子ID
        info['ID'] = str(msg_key)
        # 标题
        info['TITLE'] = msg_list.TITLE
        # 文本
        info['CONTNET'] = msg_list.MASSAGE
        # 发表时间
        info['TIME'] = msg_list.CREATED_DATE
        # 浏览量
        info['VISCOUNT'] = msg_list.VISCOUNT
        # 评论数
        info['COMMENTNUM'] = msg_list.REPLYNUM

        # 是否有按键映射方案
        has_adapter = msg_list.HASADAPTER or 0
        hashcode = msg_list.HASHCODE
        if has_adapter > 0 and hashcode is not None:
            # 获取按键映射方案下载次数
            adapter = getAdapterDownLoadCount(hashcode)
            if adapter is None:
                adapter_download_count = 0
            else:
                adapter_download_count = adapter.ADAPTER_COUNT
            info['ADAPTERNUM'] = adapter_download_count
        info['HASADAPTER'] = has_adapter

        # 查询用户资料
        u = util.getUserByAccount(msg_list.DEVICE_SN)
        if u is None:
            return {}
        # 昵称
        info['UPNAME'] = u.ACCOUNTNAME
        # 头像
        info['UPICON'] = u.ACCOUNTICON_URL
        # 权限
        info['FORM'] = u.PERMISSION

        # 查询用户积分
        score = getUserScore(msg_list.DEVICE_SN)
        info['EXP'] = score

        # 查询用户勋章
        medal_list = getMedalList(msg_list.DEVICE_SN, 0)
        return info
    except Exception as e:
        raise e
from config import MAX_TITLE_LEN
from config import MAX_CONTENT_LEN
from config import MAX_MSG_PIC_COUNT
from app.main import util
from .method import checkKeyIsExist, MaxLevelNo_GetRecordNo_SQL, insertMessagePic, insertMessagelist, updateMessagePic, updateMessagelist, getDetailTopic1

def post_topic(req):
    '''
    编辑话题
    :param req:
    :return:
    '''
    # 第一步，解析请求传入参数
    sn = req.get('SN')
    if sn is None:
        return util.bad_content()
    
    msg_id = req.get('ID')
    if msg_id is None:
        return util.bad_content()
    
    title = req.get('TITLE')
    if title is None:
        return util.bad_content()
    else:
        title_len = len(title)
        if title_len > MAX_TITLE_LEN or title_len == 0:
            return util.bad_content()
    
    content = req.get('CONTENT')
    if content is None:
        return util.bad_content()
    else:
        content_len = len(content)
        if content_len > MAX_CONTENT_LEN:
            return util.bad_content()
    
    has_game = int(req.get('HASGAME', '0'))
    if has_game == 1:
        game_name = req.get('GAMENAME')
    else:
        game_name = ''
    if game_name is None:
        return util.bad_content()
    
    has_adapter = req.get('HASADAPTER', '0')
    if has_adapter == 1:
        hashcode = req.get('ADAPTERID')
    else:
        hashcode = 0
    if hashcode is None:
        return util.bad_content()
    
    pic_info = req.get('PICINFO')
    if pic_info is None:
        return util.bad_content()
    pic_list = [pic.get('PIC') for pic in pic_info]
    pic_len = len(pic_list)
    if pic_len > MAX_MSG_PIC_COUNT:
        pic_len = MAX_MSG_PIC_COUNT
    pic_list = pic_list[0:pic_len]
    
    reply_name = req.get('TO_NAME', '')
    msg_id = int(msg_id)
    
    if msg_id == 0:
        ret = util.no_data().get('CODE')
    else:
        ret = checkKeyIsExist(msg_id)
    
    if ret == util.no_data().get('CODE'):
        ret, out_id = MaxLevelNo_GetRecordNo_SQL(msg_id)
        
        if ret == 100:
            ret = insertMessagePic(out_id, pic_list, pic_len)
            if ret == 100:
                ret = insertMessagelist(out_id, sn, reply_name, title, content, has_game, game_name, has_adapter,
                                             hashcode, pic_len, 0, reply_name, sn)
    else:
        if pic_len > 0:
            ret = updateMessagePic(msg_id, pic_list, pic_len)
        if ret == 100:
            ret = updateMessagelist(msg_id, sn, reply_name, title, content, has_game, game_name, has_adapter,
                                         hashcode, pic_len)
    
    res = {}
    res['CODE'] = ret
    return res


def get_topic_detail(req):
    sn = req.get('SN')
    if sn is None:
        return util.bad_content()
    msg_id = req.get('ID')
    if msg_id is None:
        return util.bad_content()
    else:
        msg_id = int(msg_id)
    result = getDetailTopic1(msg_id)
    if result:
        res = util.success()
        topic_info = []
        topic_info.append(result)
        res['TOPICINFO'] = topic_info
    else:
        res = util.no_data()
    return res
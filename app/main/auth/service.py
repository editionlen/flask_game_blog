from datetime import datetime

from app import logger
from app.models import db
from app.models import USERS
from app.main import util
GAME_CIRCLE = 'GAME_CIRCLE'



def syn_much_account_request(req):
    '''
    同步获取摩奇圈账号
    :param req:
    :return:
    '''
    sn = req.get('SN', '')
    dev = req.get('DEVICE', '')
    try:
        # 判断是否存在该用户
        u = USERS.query.filter_by(DEVICE_SN=sn).first()
        if u is None:
            count = USERS.query.count()
            print("dev", dev, count)
            u = USERS(DEVICE_SN=sn, DEVICE_CLASS=dev, ACCOUNT_NO=100000, GENDER=0,
                      ACCOUNTNAME='游客_%d' % (int(count) + 1), CREATED_BY=GAME_CIRCLE, CREATED_DATE=datetime.now(),
                      PERMISSION=0)
            print("result", u)
            db.session.add(u)
            print(1)
            db.session.commit()
            print(2)
            logger.debug(u)
    except Exception as e:
        db.session.rollback()
        print(e)
        logger.debug(e)
        return util.server_db_busy()
    
    res = util.success()
    res["SN"] = u.DEVICE_SN
    res["VER"] = '1.0'
    info = {}
    info['ACCOUNTNAME'] = u.ACCOUNTNAME
    info['ACCOUNTICON'] = u.ACCOUNTICON_URL or ''
    info['ADDRESS'] = u.ADDRESS or ''
    info['PHONE'] = u.PHONE or ''
    info['GENDER'] = u.GENDER
    info['BIRTHDAY'] = u.BIRTHDAY or ''
    info['COVERIMG'] = u.COVERIMG or ''
    
    res['PERSONINFO'] = info
    res['PERMISSION'] = int(u.PERMISSION or 0)
    logger.debug(res)
    return res


def modify_personal_info(req):
    '''
    修改账号基本信息
    :param req:
    :return:
    '''
    sn = req.get('SN', '')
    dev = req.get('DEVICE', '')
    # 个人信息解析
    personal_info = req.get('PERSONINFO')
    if personal_info is None:
        logger.debug('personal_info is None')
        return util.bad_content()
    else:
        name = personal_info.get('ACCOUNTNAME')
        if name is None:
            logger.debug('ACCOUNTNAME is None')
            return util.bad_content()
        elif name == '0':
            logger.debug('NAME = 0')
            return util.bad_content()
        elif len(name) > 124:
            logger.debug('NAME length > 124')
            return util.bad_content()
        elif util.check_name_is_exit(sn, name):
            return util.name_already_use()
        
        icon = personal_info.get('ACCOUNTICON', '')
        address = personal_info.get('ADDRESS', '')
        if len(address) > 252:
            return util.bad_content()
        phone = personal_info.get('PHONE', '')
        gender = personal_info.get('GENDER', '')
        birthday = personal_info.get('BIRTHDAY', '')
        
        try:
            u = USERS.query.filter_by(DEVICE_SN=sn).first()
            if u is None:
                u = USERS(DEVICE_SN=sn, ACCOUNT_NO=100000, DEVICE_CLASS=dev,
                          ACCOUNTNAME=name, ACCOUNTICON_URL=icon, GENDER=gender,
                          PHONE=phone, ADDRESS=address, CREATED_BY=GAME_CIRCLE,
                          CREATED_DATE=datetime.now(), PERMISSION=0, BIRTHDAY=birthday)
                db.session.add(u)
            else:
                u.ACCOUNTNAME = name
                u.ACCOUNTICON_URL = icon
                u.GENDER = gender
                u.PHONE = phone
                u.ADDRESS = address
                u.MODIFIED_BY = GAME_CIRCLE
                u.MODIFIED_DATE = datetime.now()
                u.BIRTHDAY = birthday
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            logger.debug('modify_personal_info db error:', e)
            return util.server_db_busy()
        
        return {"CODE": 100, "SN": u.DEVICE_SN}
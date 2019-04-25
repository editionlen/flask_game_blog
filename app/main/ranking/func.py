from app.models import STAT_RANK_TABS
from app.models import STAT_CLASS_ID
from app.models import STAT_REGION
from app.main import util
from app import logger
from .method import search_advise_game, search_rank1_list, search_rank2_list, search_rank3_list, find_game2class_by_region

def get_rank_tabs(req):
    '''
    获取摩奇圈标签
    :param req:
    :return:
    '''
    sn = req.get('DEVICE_SN', '')
    cmd_type = int(req.get('TYPE', 0))
    res = util.success()
    res['DEVICE_SN'] = sn
    res['VER'] = '1.0'
    if cmd_type == 0:
        tabs = STAT_RANK_TABS.query.all()
        if tabs is None:
            return util.no_data()
        else:
            res['INFO'] = [{"NO": tab.NO, "NAME": tab.TAB_NAME} for tab in tabs]
    else:
        class_ids = STAT_CLASS_ID.query.all()
        if class_ids is None:
            return util.no_data()
        else:
            res['INFO'] = [{"NO": class_id.APP_CLASS_ID, "NAME": class_id.CLASS_NAME} for class_id in class_ids]
    logger.debug(res)
    return res


def get_game_list(req):
    '''
    获取游戏排行榜列表
    :param req:
    :return:
    '''
    sn = req.get('SN', '')
    cmd_type = int(req.get('TYPE', 0))
    seq = int(req.get('SEQ', 0))
    size = int(req.get('LIMIT', 0))
    
    res = util.success()
    res['VER'] = '1.0'
    logger.debug(sn)
    if cmd_type == 0:
        info = search_advise_game(seq, sn, size)
    elif cmd_type == 1 and seq == 1:
        info = search_rank1_list(size)
    elif cmd_type == 1 and seq == 2:
        info = search_rank2_list(sn, size)
    elif cmd_type == 1 and seq == 3:
        info = search_rank3_list(sn, size)
    else:
        info = find_game2class_by_region(seq, size)
    
    info = filter(util.check_is_file, info)
    if info:
        res['INFO'] = [{'NAME': advise[0], 'ICON': advise[1], 'DESCRIPTION': advise[2], 'CATEGORYID': eval(advise[3])}
                       for advise in info]
    else:
        return util.no_data()
    return res


def get_gather_list(req):
    '''
    读取专区名单
    :param req:
    :return:
    '''
    logger.debug('get_gather_list')
    regions = STAT_REGION.query.all()
    info = [{"NO": region.REGION_ID, "NAME": region.REGION_NAME, "PICURL": region.REGION_URL} for region in regions]
    if info:
        res = util.success()
        res['INFO'] = info
    else:
        return util.no_data()
    
    return res
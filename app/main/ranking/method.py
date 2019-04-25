from datetime import datetime, timedelta
from config import DEFAULT_SN
from config import MAX_DAY_COUNT
from config import MAX_WEEK_COUNT

from ... import logger
from ...models import STAT_ADVISE_GAME_NUM
from ...models import STAT_ADVISE_GAME_TIME
from ...models import JSON_GAME2CLASS
from ...models import STAT_RANK_LST1
from ...models import STAT_RANK_LST2
from ...models import STAT_RANK_LST3
from ...models import STAT_REGION2CLASS
from ...models import STAT_GAME2CLASS


def search_advise_game(seq, sn, size):
    if seq == 1:
        table = STAT_ADVISE_GAME_NUM
        sort_column = STAT_ADVISE_GAME_NUM.APP_INS_NUM.desc()
    else:
        table = STAT_ADVISE_GAME_TIME
        sort_column = STAT_ADVISE_GAME_TIME.APP_USE_SUMTIME.desc()
    
    for i in range(0, MAX_DAY_COUNT + 1):
        stat_day = datetime.today() + timedelta(days=i * (-1))
        stat_day = stat_day.strftime('%Y%m%d')
        logger.debug(stat_day)
        advise = table.query.filter_by(DEVICE_SN=sn, STATDAY=stat_day).order_by(sort_column).with_entities(
            table.APP_NAME).subquery()
        result = JSON_GAME2CLASS.query.join(advise, JSON_GAME2CLASS.APP_NAME == advise.c.APP_NAME).with_entities(
            advise.c.APP_NAME, JSON_GAME2CLASS.ICON_URL, JSON_GAME2CLASS.GAME_URL, JSON_GAME2CLASS.CATEGORYID).limit(
            size).all()
        if result:
            return result
    if sn == DEFAULT_SN:
        return []
    return search_advise_game(seq, DEFAULT_SN, size)


def search_rank1_list(size):
    '''
    黑马榜
    :param size:
    :return:[(APP_NAME, ICON_URL, GAME_URL, CATEGORYID),]
    '''
    for i in range(0, MAX_WEEK_COUNT + 1):
        week_num = datetime.today() + timedelta(days=i * (-7))
        week_num = week_num.strftime('%Y%W')
        ranks = STAT_RANK_LST1.query.filter_by(WEEKNUM=week_num).order_by(
            STAT_RANK_LST1.USETOTAL.desc()).with_entities(STAT_RANK_LST1.APP_NAME).subquery()
        
        result = JSON_GAME2CLASS.query.join(ranks, JSON_GAME2CLASS.APP_NAME == ranks.c.APP_NAME).with_entities(
            ranks.c.APP_NAME, JSON_GAME2CLASS.ICON_URL, JSON_GAME2CLASS.GAME_URL, JSON_GAME2CLASS.CATEGORYID).limit(
            size).all()
        if result:
            return result
    return []


def search_rank2_list(sn, size):
    '''
    冷门榜
    :param sn:
    :param size:
    :return:[(APP_NAME, ICON_URL, GAME_URL, CATEGORYID),]
    '''
    for i in range(0, MAX_WEEK_COUNT + 1):
        week_num = datetime.today() + timedelta(days=i * (-7))
        week_num = week_num.strftime('%Y%W')
        ranks = STAT_RANK_LST2.query.filter_by(DEVICE_SN=sn, WEEKNUM=week_num).order_by(
            STAT_RANK_LST2.TIMETOTAL.desc(), STAT_RANK_LST2.USERTOTAL.asc()
        ).with_entities(STAT_RANK_LST2.APP_NAME).subquery()
        
        result = JSON_GAME2CLASS.query.join(ranks, JSON_GAME2CLASS.APP_NAME == ranks.c.APP_NAME).with_entities(
            ranks.c.APP_NAME, JSON_GAME2CLASS.ICON_URL, JSON_GAME2CLASS.GAME_URL, JSON_GAME2CLASS.CATEGORYID).limit(
            size).all()
        if result:
            return result
    if sn == DEFAULT_SN:
        return []
    return search_rank2_list(DEFAULT_SN, size)


def search_rank3_list(sn, size):
    '''
    爆肝榜
    :param sn:
    :param size:
    :return:[(APP_NAME, ICON_URL, GAME_URL, CATEGORYID),]
    '''
    for i in range(0, MAX_WEEK_COUNT + 1):
        week_num = datetime.today() + timedelta(days=i * (-7))
        week_num = week_num.strftime('%Y%W')
        ranks = STAT_RANK_LST3.query.filter_by(DEVICE_SN=sn, WEEKNUM=week_num).order_by(
            STAT_RANK_LST3.AVRTIME.desc()
        ).with_entities(STAT_RANK_LST3.APP_NAME).subquery()
        
        result = JSON_GAME2CLASS.query.join(ranks, JSON_GAME2CLASS.APP_NAME == ranks.c.APP_NAME).with_entities(
            ranks.c.APP_NAME, JSON_GAME2CLASS.ICON_URL, JSON_GAME2CLASS.GAME_URL, JSON_GAME2CLASS.CATEGORYID).limit(
            size).all()
        if result:
            return result
    if sn == DEFAULT_SN:
        return []
    return search_rank3_list(DEFAULT_SN, size)


def find_game2class_by_region(region_id, size):
    '''
    根据大分类找小分类对应游戏
    :param size:
    :return:
    '''
    id_query = STAT_REGION2CLASS.query.filter_by(REGION_ID=region_id).with_entities(STAT_REGION2CLASS.APP_CLASS_ID)
    app_name_query = STAT_GAME2CLASS.query.filter(STAT_GAME2CLASS.APP_CLASS_ID.in_(id_query)).with_entities(
        STAT_GAME2CLASS.APP_NAME)
    result = JSON_GAME2CLASS.query.filter(
        JSON_GAME2CLASS.APP_NAME.in_(app_name_query)).with_entities(
        JSON_GAME2CLASS.APP_NAME, JSON_GAME2CLASS.ICON_URL, JSON_GAME2CLASS.GAME_URL, JSON_GAME2CLASS.CATEGORYID).limit(
        size).all()
    return result
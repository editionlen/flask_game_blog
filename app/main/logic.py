#日志记录器
from .. import logger
#公用方法
from . import util
#个人模块
from .auth.service import syn_much_account_request, modify_personal_info
#游戏模块
from .ranking.func import get_rank_tabs, get_game_list, get_gather_list
#社区模块
from .posts.func import post_topic, get_topic_detail

cmd_dict = dict(SYN_MUCH_ACCOUNT = syn_much_account_request,
                MODIFY_PERSONAL_INFO = modify_personal_info,
                
                GET_RANKTABS = get_rank_tabs,
                GET_GAME_LIST = get_game_list,
                GET_GATHER_LIST = get_gather_list,
                
                POST_TOPIC = post_topic,
                GET_TOPIC_DETAIL = get_topic_detail
                )

def deal(req_dict):
    cmd = req_dict.get("CMD", '')
    func = cmd_dict.get(cmd, util.err_func)
    return func(req_dict)
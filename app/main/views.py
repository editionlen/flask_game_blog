from flask import request
import json

from . import main
from . import logic
from .. import logger

@main.route("/request", methods=['GET', 'POST'])
def deal_request():
    if request.method == 'POST':
        req = request.get_data()
        logger.debug(req.decode('utf-8'))
        req_dict = eval(eval(req.decode('utf-8')))
        if type(req_dict) == dict:
            res_dict = logic.deal(req_dict)
        else:
            res_dict = {"CODE": 80013}
        j = json.dumps(res_dict, ensure_ascii=False)
        logger.debug(j)
        return j
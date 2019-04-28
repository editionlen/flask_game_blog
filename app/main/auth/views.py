from flask import request
from flask import jsonify
import json
from . import  auth
from .service import syn_much_account_request

BAD_CONTENT = 20001  # 请求参数错误
J_MSG = {BAD_CONTENT: 'req bad content'}

class CustomFlaskErr(Exception):
    # 默认的返回码
    status_code = 400

    # 自己定义了一个 return_code，作为更细颗粒度的错误代码
    def __init__(self, return_code=None, status_code=None, payload=None):
        Exception.__init__(self)
        self.return_code = return_code
        if status_code is not None:
            self.status_code = status_code
        self.payload = payload

    # 构造要返回的错误代码和错误信息的 dict
    def to_dict(self):
        rv = dict(self.payload or ())

        # 增加 dict key: return code
        rv['return_code'] = self.return_code

        # 增加 dict key: message, 具体内容由常量定义文件中通过 return_code 转化而来
        rv['message'] = J_MSG[self.return_code]

        # 日志打印
        print(J_MSG[self.return_code])

        return rv

@auth.errorhandler(CustomFlaskErr)
def handle_flask_error(error):
    # response 的 json 内容为自定义错误代码和错误信息
    response = jsonify(error.to_dict())

    # response 返回 error 发生时定义的标准错误代码
    response.status_code = error.status_code

    return response

@auth.route("/sys_account", methods=['GET', 'POST'])
def sys_account():
    if request.method == 'POST':
        req = request.get_json()
        print(req)
        res = syn_much_account_request(req)
        return jsonify(res)
    raise CustomFlaskErr(BAD_CONTENT, status_code=400)
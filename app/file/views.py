from flask import request
#from flask import send_from_directory

import mimetypes

import os
from werkzeug.utils import  secure_filename
from flask import make_response
from flask import current_app

from config import FILE_DIR
from . import file

from .. import logger

#下载文件不存在
FILE_NOT_FOUND_PAGE = "<html><head><title>File not found</title></head><body>File not found</body></html>"
#上传文件失败
#服务器在验证在请求的头字段中给出先决条件时，没能满足其中的一个或多个。
HTTP_PRECONDITION_FAILED= '412'
#上传文件成功
UPLOAD_PAGE = "<html><head><title>File upload success</title></head><body>File upload success</body></html>"

@file.route('/', methods=['GET', 'POST'])
def upload_file():
    app = current_app._get_current_object()
    if request.method == 'POST':
        #检查post请求是否包含上传文件
        if 'filename' not in request.files:
            logger.warning('No file part')
            return HTTP_PRECONDITION_FAILED
        file = request.files['filename']
        #如果用户没有选择文件，则返回错误结果
        if file.filename == '':
            logger.warning('No selected file')
            return HTTP_PRECONDITION_FAILED
        if file:
            filename = secure_filename(file.filename)
            if filename == '':
                filename = str(hash(file.filename))
            file.save(os.path.join(FILE_DIR, filename))
            return UPLOAD_PAGE
        return HTTP_PRECONDITION_FAILED
    else:
        logger.info('much index')
        return 'much index'
#发送图片
#@file.route("/<path:filename>", methods=['GET'])
#def download_file(filename):
#    if request.method == 'GET':
#        if os.path.isfile(os.path.join(FILE_DIR, filename)):
#            return send_from_directory(FILE_DIR, filename, as_attachment=True)
#    return FILE_NOT_FOUND_PAGE

#下载图片
@file.route("/<path:filename>", methods=['GET'])
def show_file(filename):
    if request.method == 'GET':
        path_filename = os.path.join(FILE_DIR, filename)
        if os.path.isfile(path_filename):
            image_data = open(path_filename, 'rb').read()
            resp = make_response(image_data)
            content_type = mimetypes.guess_type(path_filename)
            if content_type is None:
                content_type = 'text/plain;charset=UTF-8'
            else:
                content_type = content_type[0]
                if content_type == 'text/plain':
                    content_type = content_type + ';charset=UTF-8'
            resp.headers["Content-type"] = content_type
            return resp
    return FILE_NOT_FOUND_PAGE

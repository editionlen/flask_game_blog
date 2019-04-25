import os
from ..models import USERS
from .. import logger
from config import FILE_DIR

def err_func(req):
    return dict(CODE=80009)

def success():
    return dict(CODE=100)

def part_success():
    return dict(CODE=101)

def servererror():
    return dict(CODE=110)

def bad_content():
    return dict(CODE=10006)

def name_already_use():
    return dict(CODE=80016)

def server_db_busy():
    return dict(CODE=80008)

def no_data():
    return dict(CODE=80014)



def check_is_file(filename):
    if filename is None:
        return False
    if filename[1] is None:
        return False
    filename = os.path.basename(filename[1])
    path_filename = os.path.join(FILE_DIR, filename)
    isExist = os.path.isfile(path_filename)
    if isExist == False:
        logger.debug("file %s is not exist." % path_filename)
    return isExist

def check_name_is_exit(sn, name):
    return USERS.query.filter(USERS.DEVICE_SN != sn, USERS.ACCOUNTNAME == name).first()

def getUserByAccount(Account):
    u = USERS.query.filter_by(DEVICE_SN=Account).first()
    return u

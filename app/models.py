import sys
import inspect

from . import db
from . import DB_USER, DB_GAME

current_module = sys.modules[__name__]

# 数据库 server_accounts库 ORM模型编写
class USERS(db.Model):
    '''
    用户表对应orm模型
    '''
    __bind_key__ = DB_USER
    __tablename__ = 'USERS'
    DEVICE_SN = db.Column(db.String(50), primary_key=True)
    ACCOUNT_NO = db.Column(db.Integer)
    DEVICE_CLASS = db.Column(db.String(50))
    ACCOUNTNAME = db.Column(db.String(128), unique=True)
    ACCOUNTICON_URL = db.Column(db.String(256))
    GENDER = db.Column(db.Integer)
    PHONE = db.Column(db.String(50))
    ADDRESS = db.Column(db.String(256))
    CREATED_BY = db.Column(db.String(20))
    CREATED_DATE = db.Column(db.DateTime)
    MODIFIED_BY = db.Column(db.String(20))
    MODIFIED_DATE = db.Column(db.DateTime)
    PERMISSION = db.Column(db.Integer)
    BIRTHDAY = db.Column(db.String(50))
    COVERIMG = db.Column(db.String(300))
    
    def __repr__(self):
        return '<USERS %r>' % self.DEVICE_SN


#server_games摩奇圈游戏应用榜单及帖子库
class STAT_RANK_TABS(db.Model):
    '''
    榜单标签表
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'STAT_RANK_TABS'
    NO = db.Column(db.Integer, primary_key=True)
    TAB_NAME = db.Column(db.String(100))

class STAT_CLASS_ID(db.Model):
    '''
    游戏类别表
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'STAT_CLASS_ID'
    APP_CLASS_ID = db.Column(db.Integer, primary_key=True)
    CLASS_NAME = db.Column(db.String(20), unique=True)
    TYPE_URL = db.Column(db.String(300))

class STAT_ADVISE_GAME_NUM(db.Model):
    '''
    推荐1给用户-按下载次数
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'STAT_ADVISE_GAME_NUM'
    ID = db.Column(db.Integer, autoincrement=True, primary_key=True)
    STATDAY = db.Column(db.String(20))
    DEVICE_SN = db.Column(db.String(128))
    APP_NAME = db.Column(db.String(100))
    APP_INS_NUM = db.Column(db.Integer)

class STAT_ADVISE_GAME_TIME(db.Model):
    '''
    推荐2给用户-按平均使用时长
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'STAT_ADVISE_GAME_TIME'
    ID = db.Column(db.Integer, autoincrement=True, primary_key=True)
    STATDAY = db.Column(db.String(20))
    DEVICE_SN = db.Column(db.String(128))
    APP_NAME = db.Column(db.String(100))
    APP_USE_SUMTIME = db.Column(db.Integer)

class STAT_RANK_LST1(db.Model):
    '''
    黑马榜：相比上周使用人数新进入到TOP50
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'STAT_RANK_LST1'
    WEEKNUM = db.Column(db.Integer,primary_key=True)
    APP_NAME = db.Column(db.String(100), primary_key=True)
    USETOTAL = db.Column(db.Integer)

class STAT_RANK_LST2(db.Model):
    '''
    冷门榜：使用的用户少，但使用时长高
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'STAT_RANK_LST2'
    WEEKNUM = db.Column(db.Integer,primary_key=True)
    DEVICE_SN = db.Column(db.String(128), primary_key=True)
    APP_NAME = db.Column(db.String(100), primary_key=True)
    TIMETOTAL = db.Column(db.Integer)
    USERTOTAL = db.Column(db.Integer)

class STAT_RANK_LST3(db.Model):
    '''
    爆肝榜：使用的用户少，但平均使用时长高
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'STAT_RANK_LST3'
    WEEKNUM = db.Column(db.Integer,primary_key=True)
    DEVICE_SN = db.Column(db.String(128), primary_key=True)
    APP_NAME = db.Column(db.String(100), primary_key=True)
    AVRTIME = db.Column(db.Integer)

class STAT_REGION2CLASS(db.Model):
    '''
    游戏大类和小类的对应关系
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'STAT_REGION2CLASS'
    REGION_ID = db.Column(db.Integer,primary_key=True)
    APP_CLASS_ID = db.Column(db.Integer)

class STAT_GAME2CLASS(db.Model):
    '''
    游戏名称对应的类别ID
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'STAT_GAME2CLASS'
    ID = db.Column(db.Integer, autoincrement=True, primary_key=True)
    APP_NAME = db.Column(db.String(100))
    GAME_URL = db.Column(db.String(300))
    ICON_URL = db.Column(db.String(100))
    APP_CLASS_ID = db.Column(db.Integer)

class JSON_GAME2CLASS(db.Model):
    '''
    游戏名称对应的类别ID
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'JSON_GAME2CLASS'
    ID = db.Column(db.Integer, autoincrement=True, primary_key=True)
    APP_NAME = db.Column(db.String(100))
    GAME_URL = db.Column(db.String(300))
    ICON_URL = db.Column(db.String(100))
    CATEGORYID = db.Column(db.String(100))

class STAT_REGION(db.Model):
    '''
    游戏大类表
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'STAT_REGION'
    REGION_ID = db.Column(db.Integer, primary_key=True)
    REGION_NAME = db.Column(db.String(20), unique=True)
    REGION_URL = db.Column(db.String(300))

class MSGKEYVAL(db.Model):
    '''
    帖子ID记录表
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'MSGKEYVAL'
    MSGKEY = db.Column(db.Integer, primary_key=True)
    MSGVALUE = db.Column(db.Integer)

class MESSAGELIST(db.Model):
    '''
    帖子内容记录表
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'MESSAGELIST'
    MSGKEY = db.Column(db.Integer, primary_key=True)
    LEVEL1ID = db.Column(db.Integer)
    LEVEL2ID = db.Column(db.Integer)
    LEVEL3ID = db.Column(db.Integer)
    TITLE = db.Column(db.String(512))
    MASSAGE = db.Column(db.Text)
    DEVICE_SN = db.Column(db.String(50))
    REPLY_NAME = db.Column(db.String(128))
    ADMIRECOUNT = db.Column(db.Integer)
    VISCOUNT = db.Column(db.Integer)
    COMPLAINNUM = db.Column(db.Integer)
    PICNUM = db.Column(db.Integer)
    HASADAPTER = db.Column(db.Integer)
    ADAPTER_HASHCODE = db.Column(db.Integer)
    HASGAME = db.Column(db.Integer)
    APP_NAME = db.Column(db.Integer)
    CREATED_DATE = db.Column(db.DateTime)
    MODIFIED_DATE = db.Column(db.DateTime)
    REPLYNUM = db.Column(db.Integer)
    REPLYKEY = db.Column(db.Integer)
    TOP_DATE = db.Column(db.DateTime)
    REPLY_SN = db.Column(db.String(50))
    PRI_ORI_SN = db.Column(db.String(50))
    PRI_DES_SN = db.Column(db.String(50))
    ISREAD = db.Column(db.Integer)

class MESSAGEPIC(db.Model):
    '''
    帖子图片列表
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'MESSAGEPIC'
    MSGKEY = db.Column(db.Integer, primary_key=True)
    PIC1 = db.Column(db.String(300))
    PIC2 = db.Column(db.String(300))
    PIC3 = db.Column(db.String(300))
    PIC4 = db.Column(db.String(300))
    PIC5 = db.Column(db.String(300))
    PIC6 = db.Column(db.String(300))
    PIC7 = db.Column(db.String(300))
    PIC8 = db.Column(db.String(300))
    PIC9 = db.Column(db.String(300))
    PIC10 = db.Column(db.String(300))
    PIC11 = db.Column(db.String(300))
    PIC12 = db.Column(db.String(300))
    PIC13 = db.Column(db.String(300))
    PIC14 = db.Column(db.String(300))
    PIC15 = db.Column(db.String(300))
    PIC16 = db.Column(db.String(300))
    PIC17 = db.Column(db.String(300))
    PIC18 = db.Column(db.String(300))
    PIC19 = db.Column(db.String(300))
    PIC20 = db.Column(db.String(300))
    PIC21 = db.Column(db.String(300))
    PIC22 = db.Column(db.String(300))
    PIC23 = db.Column(db.String(300))
    PIC24 = db.Column(db.String(300))
    PIC25 = db.Column(db.String(300))
    PIC26 = db.Column(db.String(300))
    PIC27 = db.Column(db.String(300))
    PIC28 = db.Column(db.String(300))
    PIC29 = db.Column(db.String(300))
    PIC30 = db.Column(db.String(300))
    PIC31 = db.Column(db.String(300))
    PIC32 = db.Column(db.String(300))
    PIC33 = db.Column(db.String(300))
    PIC34 = db.Column(db.String(300))
    PIC35 = db.Column(db.String(300))
    PIC36 = db.Column(db.String(300))
    PIC37 = db.Column(db.String(300))
    PIC38 = db.Column(db.String(300))
    PIC39 = db.Column(db.String(300))
    PIC40 = db.Column(db.String(300))
    PIC41 = db.Column(db.String(300))
    PIC42 = db.Column(db.String(300))
    PIC43 = db.Column(db.String(300))
    PIC44 = db.Column(db.String(300))
    PIC45 = db.Column(db.String(300))
    PIC46 = db.Column(db.String(300))
    PIC47 = db.Column(db.String(300))
    PIC48 = db.Column(db.String(300))
    PIC49 = db.Column(db.String(300))
    PIC50 = db.Column(db.String(300))

class USER_COMPLAINT(db.Model):
    '''
    用户投诉帖子记录表
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'USER_COMPLAINT'
    DEVICE_SN = db.Column(db.String(50), primary_key=True)
    MSGKEY = db.Column(db.Integer, primary_key=True)
    COMPLAINT_WEIGHT = db.Column(db.Integer)
    CREATE_DATE = db.Column(db.DateTime)

class KEYADAPTER_COUNT(db.Model):
    '''
    按键映射方案下载次数表
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'KEYADAPTER_COUNT'
    ADAPTER_HASHCODE = db.Column(db.Integer,primary_key=True)
    ADAPTER_COUNT = db.Column(db.Integer)
    CREATED_DATE = db.Column(db.DateTime)
    MODIFIED_DATE = db.Column(db.DateTime)

class USER_SCORE_LOG(db.Model):
    '''
    用户得分行为表
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'USER_SCORE_LOG'
    DEVICE_SN = db.Column(db.String(50), primary_key=True)
    MSGKEY = db.Column(db.Integer, primary_key=True)
    TYPE = db.Column(db.Integer, primary_key=True)
    SCORE = db.Column(db.Integer)
    GET_DATE = db.Column(db.DateTime)
    ADAPTER_HASHCODE = db.Column(db.Integer)
    LEVEL1ID = db.Column(db.Integer)
    LEVEL2ID = db.Column(db.Integer)
    LEVEL3ID = db.Column(db.Integer)
    REPLY_SN = db.Column(db.String(50))

class MEDALLIST(db.Model):
    '''
    勋章列表
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'MEDALLIST'
    MEDALID = db.Column(db.Integer, primary_key=True)
    MEDALNAME = db.Column(db.String(128))
    HAVE_MEDALICON = db.Column(db.String(256))
    NO_MEDALICON = db.Column(db.String(256))
    DEADLINE = db.Column(db.Integer)
    DESCR = db.Column(db.String)

class USER_MEDAL(db.Model):
    '''
    用户获取勋章列表
    '''
    __bind_key__ = DB_GAME
    __tablename__ = 'USER_MEDAL'
    DEVICE_SN = db.Column(db.String(50), primary_key=True)
    MEDALID = db.Column(db.Integer, primary_key=True)
    GET_DATE = db.Column(db.DateTime)
    OVER_DATE = db.Column(db.DateTime)
    DISPLAY = db.Column(db.Integer)

def get_db_all_class():
    '''
    获取数据库所有自定义类字典
    :return: 数据库所有自定义类字典
    '''
    all_class = dict()
    for name, obj in inspect.getmembers(sys.modules[__name__]):
        if inspect.isclass(obj):
            all_class[obj.__name__] = obj
    return all_class
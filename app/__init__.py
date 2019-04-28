from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from config import SQL_USER
from config import SQL_PWD
from config import SQL_ADR
from config import SQL_PORT
from config import DB_USER
from config import DB_GAME
from .log import get_logger

db = SQLAlchemy()
logger = get_logger()

def create_app():
    
    app = Flask(__name__)
    app.debug = True
    db_user_connect = 'mysql+pymysql://%s:%s@%s:%d/%s?charset=utf8' % (
        SQL_USER, SQL_PWD, SQL_ADR, SQL_PORT, DB_USER
    )
    db_game_connect = 'mysql+pymysql://%s:%s@%s:%d/%s?charset=utf8' % (
        SQL_USER, SQL_PWD, SQL_ADR, SQL_PORT, DB_GAME
    )
    app.config['SQLALCHEMY_DATABASE_URI'] = db_user_connect
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
    
    app.config['SQLALCHEMY_BINDS'] = {
        DB_USER: db_user_connect,
        DB_GAME: db_game_connect
    }
    db.init_app(app)

    from .file import file as file_blueprint
    app.register_blueprint(file_blueprint)

    from .main.auth import auth as auth_blueprint
    app.register_blueprint(auth_blueprint)
    
    from .main import main as main_blueprint
    app.register_blueprint(main_blueprint)

    logger.info('game_circle start.')
    return app
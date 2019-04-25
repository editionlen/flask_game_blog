# -*- coding: utf-8 -*-
from flask_script import Manager
from flask_script import Shell
from flask_migrate import Migrate
from flask_migrate import MigrateCommand

from app.models import db
from app.models import get_db_all_class
from app import create_app

app = create_app()
manager = Manager(app)

#迁移仓库
migrate = Migrate(app, db)

#shell使用加载的应用程序上下文自动初始化
@app.shell_context_processor
def make_shell_context():
    return dict(dict(app=app, db=db), **get_db_all_class())
manager.add_command('shell', Shell(make_context=make_shell_context))
manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    app.run(port=5002)

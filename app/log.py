import logging
import logging.handlers
from config import LOG_FILE_NAME

def get_logger():
    logfile = LOG_FILE_NAME
    file_handler = logging.handlers.TimedRotatingFileHandler(logfile, when = 'midnight', interval=1, encoding='utf-8', backupCount=7, delay=True)
    file_handler.suffix = "%Y%m%d"
    file_handler.setLevel(logging.DEBUG)
    formatter = logging.Formatter(
        "%(asctime)s - %(pathname)s[line:%(lineno)d - %(levelname)s: %(message)s")
    file_handler.setFormatter(formatter)
    
    logger = logging.getLogger('mylog')
    logger.setLevel(logging.DEBUG)
    if not len(logger.handlers):
        logger.addHandler(file_handler)
    return logger
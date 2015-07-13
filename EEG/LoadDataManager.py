import os, socket
import time, logging
from KaggleDB import KaggleDB

def initLogging():
    if not(os.path.exists('log')):
        os.makedirs('log')
    serverName = socket.gethostname()
    logfmt = '%(asctime)s\t' + serverName + '\t%(levelname)s\t%(name)s\t%(threadName)s\t%(message)s'
    datef = '%d-%m-%Y %H:%M:%S'
    fname = os.path.join('log', '%s.log'%time.strftime('%d-%m-%Y', time.localtime()))
    logging.basicConfig(level=logging.INFO, format=logfmt, datefmt=datef, filename=fname)
    
    
def initDB():
    db = KaggleDB()
    #db.TruncateAll()

def loadTrainData(fpathDir):
    if not(os.path.exists(fpathDir)):
        raise NameError('Path not exist')
    
import os, socket
import time, logging
from KaggleDB import KaggleDB
import csvAnalyzer

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
    return db

def loadRawData(fpath, is_test= False):
    db = initDB()
    if not(os.path.exists(fpath)):
        raise NameError('Path not exist')
    print 'Loading File...'
    subjCont = csvAnalyzer.analyzeFile(fpath)
    print 'Done! Inserting To DB...'
    db.InsertTrainSubject(subjCont, is_test)
    print 'Done'
    
    
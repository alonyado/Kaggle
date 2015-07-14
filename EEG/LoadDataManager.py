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
    
def logFile(fpath):
    f = open('insert.log', 'a')
    f.write('%s\n'%fpath)
    f.close()
    
def getAllDone():
    if not(os.path.exists('insert.log')):
        return []
    f = open('insert.log', 'r')
    data = f.readlines()
    f.close()
    data = map(lambda line: line.strip(), data)
    return data

def initDB():
    db = KaggleDB()
    return db

def loadRawData(db, fpath, is_test= False):
    if not(os.path.exists(fpath)):
        raise NameError('Path not exist')
    allDone = getAllDone()
    if allDone.count(fpath):
        print 'Already Done!'
        return
    print 'Loading File "%s"...'%os.path.basename(fpath)
    subjCont = csvAnalyzer.analyzeFile(fpath)
    print 'Inserting To DB...'
    succ = db.InsertRawData(subjCont, is_test)
    if succ:
        logFile(fpath)
        print 'Done!'
    else:
        print 'Error, please see logs...'
    
def loadAllRaw(db, fDir, is_test=False):
    if not(os.path.exists(fDir)):
        raise NameError('Path not exist')
    allFiles = os.listdir(fDir)
    allFiles = filter(lambda f : f.endswith('_data.csv') , allFiles)
    for fil in allFiles:
        fullPath = os.path.join(fDir, fil)
        loadRawData(db, fullPath, is_test)

initLogging()
db = initDB()

loadRawData(db,'/home/alonyado/Desktop/Kaggle/Data/EEG/train/subj1_series1_data.csv')
#loadAllRaw(db, '/home/alonyado/Desktop/Kaggle/Data/EEG/train')
#loadAllRaw(db, '/home/alonyado/Desktop/Kaggle/Data/EEG/test', True)
import psycopg2, traceback, logging

class KaggleDB:

    def __init__(self, maxErrorToRest = 3):
        self.__conn = psycopg2.connect("dbname=postgres user=postgres")
        self.__errorCount = 0
        self.__maxError = maxErrorToRest
        self.__logger = logging.getLogger(__name__)

    def close(self):
        self.__conn.close()

    def GetTableFields(self, tbl_name = 'eeg_subjects'):
        #fields = ['subject_num','series_numeric','frame_numeric', \
        #'is_test','fp1','fp2','f7','f3','fz','f4','f8','fc5','fc1',\
        #'fc2','fc6','t7','c3','cz','c4','t8','tp9','cp5','cp1','cp2'\
        #,'cp6','tp10','p7','p3','pz','p4','p8','po9','o1','oz','o2',\
        #'po10']    
        fields = list()
        if (self.__conn == None):
            raise NameError('Connection already closed')
        try:
            self.__cur = self.__conn.cursor()   
            self.__cur.execute(""" SELECT  column_name 
FROM information_schema.columns where table_schema = 'kaggle'
and table_name = %s 
order by ordinal_position
""", [tbl_name])    
            rowsTemp = self.__cur.fetchall()
            #print len(rowsTemp)
            self.__cur.close()
            rowsData = map(lambda row: row[0], rowsTemp)
            for r in rowsData:
                fields.append(r)
                
        except:
            self.__logger.error(traceback.format_exc())
            self.__errorCount = self.__errorCount + 1
            if (self.__errorCount >= self.__maxError):
                self.__errorCount = 0
                try:
                    self.__conn.close()
                except:
                    self.__logger.error(traceback.format_exc())
                self.__conn = psycopg2.connect("dbname=postgres user=postgres") 

        return fields

    def __subjectToRow(self, tblFields, subProps, is_test = False):
        ls = list()
        for f in tblFields:
            if f == 'is_test':
                ls.append(is_test)
            else:
                if not(subProps.has_key(f)):
                    raise NameError('Field Not Found - %s'%f)
                ls.append(float(subProps[f]))
        return ls

    def __subjectTagToRow(self, tblFields, subProps):
        ls = list()
        for f in tblFields:
            ef = f
            if f.startswith('is_'):
                ef = f[3:]
            if not(subProps.has_key(ef)):
                raise NameError('Field Not Found - %s'%f)
            ls.append(float(subProps[ef]))
        return ls

    def InsertRawData(self, subjectsProps, is_test = False):
        transFunc = lambda tblF,x: self.__subjectToRow(tblF, x, is_test)
        self.__insertData(subjectsProps, 'eeg_subjects', transFunc)
    
    def InsertTaggedData(self, subjectsProps):
        transFunc = lambda tblF,x: self.__subjectTagToRow(tblF, x)
        self.__insertData(subjectsProps, 'eeg_tagging_train', transFunc)    
    
    def __insertData(self, subjectsProps, table_name, transFunction):
        tblFields = self.GetTableFields(table_name)
        allRows = map(lambda x: transFunction(tblFields, x), subjectsProps)
        flCnt = len(tblFields)
        sHeader = '%s,' * flCnt 
        sHeader = sHeader[0:-1]
        if (self.__conn == None):
            raise NameError('Connection already closed')
        try:
            self.__cur = self.__conn.cursor()
            self.__cur.executemany("""insert into kaggle.%s values(%s)
                                ;"""%(table_name ,sHeader),
                               allRows)
            self.__cur.close()
            self.__conn.commit()
            return True
        except:
            self.__logger.error(traceback.format_exc())
            self.__errorCount = self.__errorCount + 1
            if (self.__errorCount >= self.__maxError):
                self.__errorCount = 0
                try:
                    self.__conn.close()
                except:
                    self.__logger.error(traceback.format_exc())
                self.__conn = psycopg2.connect("dbname=postgres user=postgres")
            return False

import csvAnalyzer, xmlAnalyzer, re

class Configuration:
    def __init__(self):
        self.schema_name = 'KAGGLE_SEQ'
        self.tableName = 'TestData'
        self.dataDir = '/home/nolim/Downloads/Kaggle/seq' #folder with files to upload to db - search recursive in this folder for
        # files that return true for self.filesFormatFunc condition. it can load multipal files to same table. when it fails
        # next time it starts, its skips the already success files uploaded
        
        self.filesFormatFunc = lambda f : f.endswith('test.csv') #files filter to upload to that table, you can use regex also
        self.dataAnalyzerFun = lambda f:  csvAnalyzer.analyzeFile(f, delimiter = ',', #delimeter fot csv
                                                                  manipulationFunc = None, #dictionary for functions to manipulate fields in the csv. example 1
                                                                  additionalConstFields = None) #additionalFields to add for table
        
        # Example 1: manipulation function for fields:
        # manipulationFunc = dict()
        # manipulationFunc['field_name_in_csv'] = lambda field_value : field_value * 100
        # this manipulation function change the field "field_name_in_csv" and multiply it by 100
        # you can provide more manipulations to other fields
        
        #run this program with python LoadDataManager.py

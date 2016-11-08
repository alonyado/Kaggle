import csvAnalyzer, xmlAnalyzer

class Configuration:
    def __init__(self):
        self.schema_name = 'KAGGLE_SEQ'
        self.dataDir = '/home/nolim/Downloads/Kaggle/seq'
        #self.tableName = 'TrainData'
        #self.filesFormatFunc = lambda f : f.endswith('train.csv')
        self.tableName = 'TestData'     
        self.filesFormatFunc = lambda f : f.endswith('test.csv')
        self.dataAnalyzerFun = lambda f:  csvAnalyzer.analyzeFile(f, delimiter = ',"', manipulationFunc = None, additionalConstFields = None)
        

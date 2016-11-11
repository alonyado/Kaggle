import re, sys, os

def splitLine(line, delimiter, supportQ = True):
    currMatch = 0
    escaping = False
    qCnt = False
    bufferStr = ''

    tokens = list()
    for ch in line:
        if ch == '"' and not(escaping):
            qCnt = not(qCnt)
            
        escaping = (ch =='\\')
        
        if ch == delimiter[currMatch] and (not(qCnt) or not(supportQ)):
            currMatch = currMatch + 1
            if currMatch >= len(delimiter):
                currMatch = 0
                tokens.append(bufferStr)
                bufferStr = ''
        else:
            bufferStr = bufferStr + ch

    if len(bufferStr) > 0:
        tokens.append(bufferStr)

    return tokens
            
def analyzeCsv(csvContent, delimiter = ',', supportQ = True, manipulationFunc = None, additionalConstFields = None):
    if manipulationFunc <> None and type(manipulationFunc) <> dict:
        raise NameError('passed manipulationFunc which should be dict object')
    if additionalConstFields <> None and type(manipulationFunc) <> dict:
        raise NameError('passed additionalConstFields which should be dict object')
    res = list()
    
    allLines = csvContent.splitlines()
    allLines = filter(lambda x: len(x.strip()) > 0, allLines)
    header = allLines[0]
    header = map(lambda x: x.strip().strip('"').lower() ,header.split(delimiter))
    
    fieldCnt = len(header)
    allLines = allLines[1:len(allLines)]    

    lineNum = 1
    for line in allLines:
        lineNum = lineNum + 1
        allTokens = splitLine(line, delimiter, supportQ)
        allTokens = map(lambda t: t.strip().strip('"') ,allTokens)
        d = dict()
        if len(allTokens) <> fieldCnt:
            sys.stderr.write('%s\n'%line)
            raise NameError('Csv Format Exception in line %d'%lineNum)
            
        for i in xrange(0, fieldCnt):
            if len(header[i]) == 0:
                continue
            if manipulationFunc <> None and manipulationFunc.has_key(header[i]):
                handleFunc = manipulationFunc[header[i]]
                d[header[i]] = handleFunc(allTokens[i])
            else:
                d[header[i]] = allTokens[i]
        if additionalConstFields <> None:
            for exF, exV in additionalConstFields.iteritems():
                d[exF] = exV
        res.append(d)
        
    header = filter(lambda x: len(x) > 0 ,header)    
    return res, header

def analyzeFile(fpath, delimiter = ',', supportQ = True, manipulationFunc = None, additionalConstFields = None):
    if not(os.path.exists(fpath)):
        raise NameError('Path not exist')
    f = open(fpath, 'r')
    data = f.read()
    f.close()
    return analyzeCsv(data, delimiter, supportQ, manipulationFunc, additionalConstFields)

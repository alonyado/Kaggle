import re, sys, os

def analyzeID(idVal):
    subjectRegex = re.compile('(?<=subj)[0-9]+')
    seriesRegex = re.compile('(?<=series)[0-9]+')
    frameRegex = re.compile('(?<=_)[0-9]+$')
    
    subjectN = subjectRegex.findall(idVal)
    seriesN = seriesRegex.findall(idVal)
    frameN = frameRegex.findall(idVal)
    if len(subjectN) <> 1:
        raise NameError('Not in format - subj regex')
    if len(seriesN) <> 1:
        raise NameError('Not in format - series regex')
    if len(frameN) <> 1:
        raise NameError('Not in format - frame regex')
    d = dict()
    d['subject_num'] = subjectN[0]
    d['series_numeric'] = seriesN[0]
    d['frame_numeric'] = frameN[0]
    return d

def analyzeCsv(csvContent):
    res = list()
    
    allLines = csvContent.splitlines()
    allLines = filter(lambda x: len(x.strip()) > 0, allLines)
    header = allLines[0]
    header = map(lambda x: x.strip().strip('"').lower() ,header.split(','))
    fieldCnt = len(header)
    tokenSpliter = re.compile(',')
    allLines = allLines[1:len(allLines)]    
    
    for line in allLines:
        allTokens = tokenSpliter.split(line)
        allTokens = map(lambda t: t.strip().strip('"') ,allTokens)
        d = dict()
        if len(allTokens) <> fieldCnt:
            sys.stderr.write('%s\n'%line)
            raise NameError('Csv Format Exception')
        for i in xrange(0, fieldCnt):
            if header[i] == 'id':
                idTokens = analyzeID(allTokens[i])
                for idKey,idVal in idTokens.iteritems():
                    d[idKey] = idVal
            else:
                d[header[i]] = allTokens[i]
        res.append(d)
        
    return res
def analyzeFile(fpath):
    if not(os.path.exists(fpath)):
        raise NameError('Path not exist')
    f = open(fpath, 'r')
    data = f.read()
    f.close()
    return analyzeCsv(data)
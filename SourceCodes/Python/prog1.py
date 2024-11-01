



#Test for input aabababa
#aaabbccxxyyzzkkdrf
#daxxyybbcccb
#aabababaaaaa
#yaabababaaaaaptt


inputText = input('Please enter Text to find balanced substring : ')

firstChar = inputText[0]
secondChar = ""
firstCharCount = 1
firstCharPosition = 0
secondCharCount = 0 # initialize secondCharCount for future comparisons
secondCharPostion = -1
inputLength = len(inputText)
balancedStringCount = 1 #counter for number of Balanced Strings in the input
balancedStringList = []
finalList = []
largestStringSize = 0

def findBalancedString():
    minCount =  0
    global firstChar
    global secondChar
    global firstCharCount
    global firstCharPosition
    global secondCharCount
    global secondCharPostion
    global balancedStringCount
    global balancedStringList
    global largestStringSize

    firstCharCount_tmp = firstCharCount
    secondCharCount_tmp = secondCharCount
    substrLength = firstCharCount_tmp + secondCharCount_tmp
    if (firstCharCount_tmp == secondCharCount_tmp):
        if (largestStringSize <= (firstCharCount_tmp + secondCharCount_tmp)):
            largestStringSize = firstCharCount_tmp + secondCharCount_tmp
            balancedString = inputText[firstCharPosition:firstCharPosition+firstCharCount_tmp+secondCharCount_tmp:1]
            balancedStringList.append(balancedString)
    elif (abs(firstCharCount_tmp - secondCharCount_tmp) >= 1):
        if (firstCharCount_tmp < secondCharCount_tmp):
            minCount = firstCharCount_tmp 
        else: 
            minCount = secondCharCount_tmp
        startPosition = firstCharPosition
        stringNotFound = True
        #print(' startPostion %s minCount %s' %(startPosition, minCount))
        while (stringNotFound):
            firstCharCount_tmp = 0
            secondCharCount_tmp = 0
            endPostion = startPosition + (minCount * 2) - 1
            if (endPostion < substrLength):
                for index in range(startPosition, endPostion+1):
                    #print('index %s , inputText %s' %(index, inputText[index]))
                    if (inputText[index] == firstChar):
                        firstCharCount_tmp += 1
                    elif (inputText[index] == secondChar):
                        secondCharCount_tmp += 1
                    if (firstCharCount_tmp == secondCharCount_tmp):
                        if (largestStringSize <= (firstCharCount_tmp + secondCharCount_tmp)):
                            largestStringSize = firstCharCount_tmp + secondCharCount_tmp
                            balancedString = inputText[startPosition:startPosition+firstCharCount_tmp+secondCharCount_tmp:1]
                            balancedStringList.append(balancedString)
                        balancedStringCount += 1                                
                #if (firstCharCount_tmp == secondCharCount_tmp):
                    #stringNotFound = False
                #else:
                startPosition = startPosition + 1       
            else:
                minCount -= 1
                if (minCount < 2):
                    stringNotFound = False

if(len(inputText) < 2):
    finalList=[]
else:
    curPos = 1
    while ((curPos < inputLength) & (inputText[curPos] == firstChar)): #if first char repeats n times then count that
            firstCharCount += 1
            curPos += 1
    if (curPos < inputLength): #if not repeat of initial char, then assign to secondChar
        secondChar = inputText[curPos]
        secondCharCount = 1
        secondCharPostion = curPos
        curPos += 1

    if(inputLength == 2): # if only 2 chars in input, check if each char present once to make balanced string
        if (firstCharCount == secondCharCount):
            finalList.append(inputText)
    else:
        for x in range (curPos, len(inputText)):
            if (inputText[x] == firstChar):
                firstCharCount += 1
            elif (inputText[x] == secondChar):
                secondCharCount += 1
            else:
                findBalancedString()
                if (inputText[x-1] == secondChar):
                    firstChar = secondChar
                    firstCharCount = secondCharCount
                    firstCharPosition = secondCharPostion
                    secondChar = inputText[x]
                    secondCharCount = 1
                    secondCharPostion = x
                elif (inputText[x-1] == firstChar):
                    secondChar = inputText[x]
                    secondCharCount = 1
        if (firstCharPosition < x): # to check if there is a balanced string after the last print position when the end of string is reached
                findBalancedString()
        finalList = []
        for item in balancedStringList:
            if len(item) == largestStringSize:
               finalList.append(item)   
for item in finalList:
    print(item)      




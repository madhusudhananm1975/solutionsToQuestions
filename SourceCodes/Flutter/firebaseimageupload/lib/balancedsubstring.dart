//Test for input aabababa
//aaabbccxxyyzzkkdrf
//daxxyybbcccb
//aabababaaaaa
//yaabababaaaaaptt
import 'dart:developer';




int firstCharCount = 1;
int firstCharPosition = 0;
int secondCharCount = 0; // initialize secondCharCount for future comparisons
int secondCharPostion = -1;
int inputLength = inputText.length;
int largestStringSize = 0;
int balancedStringCount = 1; //counter for number of Balanced Strings in the input
List<String> balancedStringList = [];
List<String> finalList = [];
String firstChar = inputText[0];
String secondChar = "";
late String inputText;


// traverse through the substring (start to end then start+1 to end and so on) to find balanced substring
void findBalancedString()
{

    int minCount =  0;


    int firstCharCountTmp = firstCharCount;
    int secondCharCountTmp = secondCharCount;
    int substrLength = firstCharCountTmp + secondCharCountTmp;
    String balancedString = "";
    int startPosition;
    bool stringNotFound = true;
    int endPostion = 0;
    //log('fc ', name: '$firstChar, $firstCharCountTmp, $firstCharPosition');
    //log('sc ', name: '$secondChar, $secondCharCountTmp, $secondCharPostion');
    if (firstCharCountTmp == secondCharCountTmp)
    {
        if (largestStringSize <= (firstCharCountTmp + secondCharCountTmp))
        { 
            largestStringSize = firstCharCountTmp + secondCharCountTmp;
            balancedString = inputText.substring(firstCharPosition, firstCharPosition+firstCharCountTmp+secondCharCountTmp);
            balancedStringList.add(balancedString);
         }
    }
    else if (((firstCharCountTmp - secondCharCountTmp).abs()) >= 1)
    {
        if (firstCharCountTmp < secondCharCountTmp)
        { 
            minCount = firstCharCountTmp ;
        }
        else
        {
            minCount = secondCharCountTmp;
        }
        startPosition = firstCharPosition;
        stringNotFound = true;
        while (stringNotFound)
        {
            firstCharCountTmp = 0;
            secondCharCountTmp = 0;
            endPostion = startPosition + (minCount * 2) - 1;
            if (endPostion < substrLength)
            {
                for (var index = startPosition; index < endPostion+1; index++)
                { 
                    if (inputText[index] == firstChar)
                    {
                        firstCharCountTmp += 1;
                    }
                    else if (inputText[index] == secondChar)
                    {
                        secondCharCountTmp += 1;
                    }
                    if (firstCharCountTmp == secondCharCountTmp)
                    { 
                        if (largestStringSize <= (firstCharCountTmp + secondCharCountTmp))
                        { 
                            largestStringSize = firstCharCountTmp + secondCharCountTmp;
                            balancedString = inputText.substring(startPosition, startPosition+firstCharCountTmp+secondCharCountTmp);
                            balancedStringList.add(balancedString);
                         }
                        balancedStringCount += 1;
                    }
                }
                startPosition = startPosition + 1;
            }
            else{  
                minCount -= 1;
                if (minCount < 2){
                    stringNotFound = false;
                  }
            }
        }
     }
}
 

List<String> balancedSubString(input)
{
    inputText = input;
    firstChar = inputText[0];
    int curPos = 0;
    int position = 0;
    balancedStringList = [];
    //log('char is ',  name:inputText);

    if(inputText.length < 2)
    {
        finalList=[];
    }
    else
    {
        curPos = 1;
        //log('char is ',  name:inputText[curPos]);
        while ((curPos < inputLength) & (inputText[curPos] == firstChar))
        {
                firstCharCount += 1;
                curPos += 1;
        } //if first char repeats n times then count that
        if (curPos < inputLength)
        {
            secondChar = inputText[curPos];
            secondCharCount = 1;
            secondCharPostion = curPos;
            curPos += 1;
        } //if not repeat of initial char, then assign to secondChar
        if(inputLength == 2)
        { 
            if (firstCharCount == secondCharCount)
            {
                finalList.add(inputText);
              }
        } // if only 2 chars in input, check if each char present once to make balanced string
        else{ 
            for (position = curPos; position < inputText.length; position++ )
            {
                if (inputText[position] == firstChar)
                {
                    firstCharCount += 1;
                }
                else if (inputText[position] == secondChar)
                {
                    secondCharCount += 1;
                }
                else
                { 
                      findBalancedString();
                      if (inputText[position-1] == secondChar)
                      { 
                        firstChar = secondChar;
                        firstCharCount = secondCharCount;
                        firstCharPosition = secondCharPostion;
                        secondChar = inputText[position];
                        secondCharCount = 1;
                        secondCharPostion = position;
                      }
                      else if (inputText[position-1] == firstChar)
                      { 
                        secondChar = inputText[position];
                        secondCharCount = 1;
                      }
                }


            }
            if (firstCharPosition < position)
            { 
                    findBalancedString();
            } // to check if there is a balanced string after the last print position when the end of string is reached

            finalList = [];

            for (var item in balancedStringList) { 
                if (item.length == largestStringSize)
                {
                  finalList.add(item); 
                }
            }
        }
    }
      
    for (var item in finalList) { 
        log('items' , name: item.toString());  
    }
    return finalList;
   

}

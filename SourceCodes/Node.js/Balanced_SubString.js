//Test for input aabababa
//aaabbccxxyyzzkkdrf
//daxxyybbcccb
//aabababaaaaa
//yaabababaaaaaptt
//aabbccddefghjijjjjjkkkkkj

let firstChar ="";
let secondChar = "";
let firstCharCount = 0;
let secondCharCount = 0; 
let firstCharPosition = 0;
let startPosition = 0; // if aabbccdd then startPosition will point to start (b) of substring in iteration 2 
let endPosition = 0; // if aabbccdd is string then endPosition on 1st iteration will point to th last b of substring at Position 3
let nextPosition = 0; // if aabbcc is string then after 1st substring processing of aabb, this nextPosition will point to b followed by last a

let largestStringSize = 0; // to compare the balanced substring lengths and keep the current largest length for substring
let balancedStringList = []; //list of all balanced substrings found
let finalList = []; // keep only the largest substrings of equal length out of balancedStringList


let inputText = "";
let inputLength = 0;


// traverse through the substring (this function will be called when only 2 unique chars in substring like 'aabbbbbbbaab')
function findBalancedString()
{

   let minCount =  0; // if aabbabbbcc is string then minCount will have 3 as minCount for the substring aabbabbb
   let balancedString = "";
   let initialPostion = startPosition;

   minCount = firstCharCount ; 
   if (secondCharCount < firstCharCount )
   { 
        minCount = secondCharCount;
   }

   curPos = startPosition;
   nextPosition = 0;
   secondCharCount = 0;
   firstCharCount = 1
   firstChar = inputText[startPosition];
   if ((firstCharCount == minCount) && (nextPosition == 0))
    {
        nextPosition = curPos + 1;
    }
    curPos += 1;


   while (curPos <= endPosition)
   {
        if (inputText[curPos]  == firstChar)
            {
                firstCharCount += 1;    
            }
        else 
            {
                secondCharCount += 1;
            }
        // if the substring passed is abbaa but the entire string is abbaacc then the nextPosition has to be a that follows b so that aacc can be balanced subString
        // if the substring passed is aababbccc then NextPosition has to be b that follwos last a so that bbcc can be the next balanced substring
        if ((firstCharCount == minCount) && (nextPosition == 0))
        {
            nextPosition = curPos + 1;
        }
        else if ((secondCharCount == minCount)  && (nextPosition == 0)) // if nextPosition is already defined based on minCount reached of 1st or 2nd char end, then need not assign again
        {
            nextPosition = curPos + 1;
        }
        if ((firstCharCount == secondCharCount) && (firstCharCount == minCount)) // if 1st char count == 2nd char count == minCount
        {
                if (largestStringSize <= (firstCharCount + secondCharCount))
                { 
                    largestStringSize = firstCharCount + secondCharCount;
                    balancedString = inputText.substring(curPos - minCount*2 +1, curPos+1);
                    balancedStringList.push(balancedString);
                 }
                 // if aabba is the string then after finding aabb, increment the startposition so that we can detect abba
                 startPosition += 1;
                 curPos = startPosition;
                 firstChar = inputText[curPos];
                 firstCharCount = 1;
                 curPos += 1;
                 secondCharCount = 0;
        }
        else
        {
                curPos += 1;
        }          
        
        if ((curPos >= endPosition) && ((initialPostion) < endPosition)) // if String is aab then need to process ab
        {
            startPosition += 1;
            curPos = startPosition;
            firstChar = inputText[curPos];
            firstCharCount = 1;
            curPos += 1;
            secondCharCount = 0;
            initialPostion += 1;
        }
    }
}


function processString(input)
{
   inputText = input;
   inputLength = inputText.length;
   firstChar = inputText[0];
   firstCharCount = 1;
   firstCharPosition = 0;
   startPosition = 0;
   endPosition = 0;
   secondChar = "";
   secondCharCount = 0; 
   largestStringSize = 0;
   curPos = 0;
   balancedStringList = [];
   finalList = [];
   finalList.length = 0;
   balancedStringList.length = 0;

   if(inputText.length < 2)
   {
       finalList=["Single Character input, so no balanced substring present."];
   }
   else
   {
       curPos = 1;
       while(curPos < inputLength)
       {
           //if first char repeats n times then count that
           while ((curPos < inputLength) & (inputText[curPos] == firstChar))
           {
                  firstCharCount += 1;
                  curPos += 1;
           } 
          //if not repeat of initial char, then assign to secondChar
          if (curPos < inputLength)
          {
                  secondChar = inputText[curPos];
                  secondCharCount = 1;
                  curPos += 1;
          } 

                       
          newCharNotFound = true;
          while ((curPos < inputLength) && (newCharNotFound))
          {               
                if (inputText[curPos] == firstChar)
                {
                    firstCharCount += 1;
                    curPos += 1;
                }
                else if (inputText[curPos] == secondChar)
                {
                    secondCharCount += 1;
                    curPos += 1;

                }
                else //if new char found and not a balanced substring then call findBalancedString
                { 
                    newCharNotFound = false;
                    nextPosition = curPos;
                    endPosition = curPos; 
                    findBalancedString();
                    startPosition = nextPosition;
                    curPos = startPosition;
                    firstChar = inputText[curPos];
                    firstCharCount = 1;
                    firstCharPosition = curPos;
                    curPos += 1;
                    secondChar = "";
                    secondCharCount = 0;                                                          
                }                
          }
        }
        if (firstCharPosition <= curPos) // to check if there is a balanced string after the last print position when the end of string is reached
        { 
            endPosition = curPos;
            findBalancedString();
        } 
        finalList = [];
        balancedStringList.forEach((item) => {
                                                if (item.length == largestStringSize)
                                                    {
                                                        finalList.push(item); 
                                                    }
                                            });
    }
    finalList.forEach((element) => console.log(element));

};


const { nextTick } = require('node:process');
//Main for  input and invoking the functions
const readline = require('node:readline');
const rl = readline.createInterface({
 input: process.stdin,
 output: process.stdout,
});
rl.question(`Enter String to find balanced substring(s)? `, text => {

    processString(text);
    rl.close();
});

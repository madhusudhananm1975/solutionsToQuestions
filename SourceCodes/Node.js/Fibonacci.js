/* Fibonacci Nth Term */

//0,1,1,2,3,5,8,13,21,34,55,...

fibList = [0, 1]

function fibfunc(n)
{
    if (n<= fibList.length)
    {
        return fibList[n-1]; // if previously calculated value is available, then return it.
    }
   else
   {
        fib = fibfunc(n-1)+fibfunc(n-2);
        fibList.push(fib); // store the calculated values in list so that need not calculate again
        return fib;
   }
}

const readline = require('node:readline');
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});
rl.question(`To find Nth Fibonacci term, enter value for N? `, num => {
    n = Number(num);
    if ( n < 1)
        {
            console.log ('Invalid input. Input has to be > 0');
        }   
        else{
            fibVal = fibfunc(n);
            console.log ('Fibonacci value at postion ' + num + ' is : ' + fibVal);
            console.log ('Please note, 0 is considered as the value for 1st term in the series');
        }
  rl.close();
});


   
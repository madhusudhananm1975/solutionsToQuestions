List <double> fibList = [0, 1];
late double fib;
double fibfunc(n)
{
    if (fibList.length >= n)
    {
        return fibList[n-1]; // if previously calculated value is available, then return it.
    }       
    else{
        fib = fibfunc(n-1)+fibfunc(n-2);
        fibList.add(fib); // store the calculated values in list so that need not calculate again
        return fib;

    }
}
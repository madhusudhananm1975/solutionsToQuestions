#0,1,1,2,3,5,8,13,21,34,55,...

fibList = [0, 1]

def fibfunc(n):
    if n<= len(fibList):
        return fibList[n-1] # if previously calculated value is available, then return it.
    else:
        fib = fibfunc(n-1)+fibfunc(n-2)
        fibList.append(fib) # store the calculated values in list so that need not calculate again
        return fib

       

n = int(input ('Please enter a numeric value for N to determine Nth postion value in Fibanocci series : '))
if ( n < 1):
   print ('Invalid input. Input has to be > 0')
else:
   print ('value at postion %s is : %s' %(str(n),str(fibfunc(n))))



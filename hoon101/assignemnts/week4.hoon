::  week4
::
::  If we list all the natural numbers below 10 that are multiples of 3 or 5,
::  we get 3, 5, 6 and 9. The sum of these multiples is 23.
::
::  Find the sum of all the multiples of 3 or 5 below 1000.
::
::
/?    310
::
=>  |%
    ++  multiple-3-5
      |=  a=@  ^-  ?
      |(=((mod a 3) 0) =((mod a 5) 0))
    --
::
|=  x=*
^-  @
=|  count=@
=|  sum=@
|-  ^-  @
?:  =(count 1.000)  sum
%=  $
  sum    ?:((multiple-3-5 count) (add sum count) sum)
  count  +(count)
==

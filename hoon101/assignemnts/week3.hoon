::  week3
::
::  1. Comment each line of code from the tail-call optimized recursion example
::  to explain what the code is doing.
::
::  2. Build a naked generator that accepts a list as its argument, and returns
::  the third element of that list. Do not use any standard-library functions.
::
::  Lists are kinds of nouns that are written as [1 2 3 4 ~].
::
/?    310
::
::  a faster way would be to just return:
::  &3:a
::
|=  a=(list *)
=+  i=2
|-
?~  a  ~
?:  =(i 0)  i.a
$(i (dec i), a t.a)

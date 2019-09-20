::  week2
::
::  Build a naked generator that takes a noun and checks if that noun is a cell
::  or an atom. If that input noun is an atom, check if it’s even or odd.
::
::  The output should be of the tape type. A tape is a string.
::
/?    310
::
|=  a=^
?^  "cell"
?:  (= (mod a 2) 0)
  "even atom"
"uneven atom"

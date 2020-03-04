::  week5
::
::  Here is a generator that checks for counterexamples of the unproven Goldbach
::  conjecture, up to a certain number.

::  1. Add comments to each line to explain what the code is doing.
::
::  2. Here is the skeleton of a naked generator. Complete it so that it’s that
::  takes a tape as an argument and produces a tape as it’s output which is a
::  translation of the input tape into Morse Code.
::
/?    310
::
|=  raw=tape
=<
  |-  ^-  tape
  ?~  raw  ~
  [(convert i.raw) $(raw t.raw)]
|%
++  convert
  |=  a=@t
  ^-  @t
  ::  (~(got by a) b) produces the value located at key b within map a
  =/  chart  (~(got by table) a)
  chart
::
++  table
  %-  my
  :~  :-  'A'  '.-'
      :-  'B'  '-...'
      :-  'C'  '-.-.'
      :-  'D'  '-..'
      :-  'E'  '.'
      :-  'F'  '..-.'
      :-  'G'  '--.'
      :-  'H'  '....'
      :-  'I'  '..'
      :-  'J'  '.---'
      :-  'K'  '-.-'
      :-  'L'  '.-..'
      :-  'M'  '--'
      :-  'N'  '-.'
      :-  'O'  '---'
      :-  'P'  '.--.'
      :-  'Q'  '--.-'
      :-  'R'  '.-.'
      :-  'S'  '...'
      :-  'T'  '-'
      :-  'U'  '..-'
      :-  'V'  '...-'
      :-  'W'  '.--'
      :-  'X'  '-..-'
      :-  'Y'  '-.--'
      :-  'Z'  '--..'
      :-  '0'  '-----'
      :-  '1'  '.----'
      :-  '2'  '..---'
      :-  '3'  '...--'
      :-  '4'  '....-'
      :-  '5'  '.....'
      :-  '6'  '-....'
      :-  '7'  '--...'
      :-  '8'  '---..'
      :-  '9'  '----.'
  ==
--

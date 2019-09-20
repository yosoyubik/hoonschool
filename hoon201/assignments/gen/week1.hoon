::  Week 1:
::    Deal two hands and check which one wins according to poker rules
::
/+  playing-cards, poker
::
=,  poker
=,  playing-cards
::
!:
::
:-  %say
|=  [[* eny=@uv *] *]
=/  d=deck  (shuffle-deck make-deck eny)
=^  a=deck  d  (draw 5 d)
=^  b=deck  d  (draw 5 d)
:-  %noun
[(compare a b) a^b]
::

::  Week 4:
::    Set a reminder: Extension of the egg timer.
::    Instead of giving it a time to go off, give it a time stamp.
::
!:
::
|%
+$  effect   (pair bone syscall)
+$  syscall
  $%  [%wait path @da]
  ==
--
|_  [bol=bowl:gall ~]
++  poke-noun
  |=  t=@da
  ^-  (quip effect _+>.$)
  ~&  t
  :_  +>.$
  [ost.bol %wait /egg-timer t]~
::
++  wake
  |=  [=wire error=(unit tang)]
  ^-  (quip effect _+>.$)
  ~&  "Timer went off!"
  [~ +>.$]
--

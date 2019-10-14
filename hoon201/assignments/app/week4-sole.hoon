::  Week 4:
::    Set a reminder: Extension of the egg timer.
::    Instead of giving it a time to go off, give it a time stamp.
::
::    ~zod:week4-sole | Enter timestamp (e.g. 2019.10.14..04.34.46..1435) |
::
/-  *sole
/+  *sole
::
!:
::
=>  |%
    +|  %models
    ::
    +$  state
      $:  consol=[conn=bone state=sole-share]
      ==
    ::
    +$  effect   (pair bone syscall)
    ::
    +$  syscall
      $%  [%wait path @da]
          [%peer wire dock path]
          [%diff diff-data]
      ==
    ::
    +$  diff-data
      $%  [%sole-effect sole-effect]
      ==
    --
::
|_  [bol=bowl:gall %0 sat=state]
::
++  timer  .
::
++  prep
  =>  |%
      ++  states
        $%  [%0 s=state]
        ==
      --
  |=  old=(unit states)
  ^-  (quip move _timer)
  ?~  old
    ::  we haven't modified the previous state
    ::
    [~ timer]
  ::  the old state needs to be adapted to the new one
  ::
  ?-  -.u.old
    %0  [~ timer(sat s.u.old)]
  ==

++  poke-noun
  |=  t=@da
  ^-  (quip effect _timer)
  ~&  t
  (activate-timer t)
::
++  wake
  |=  [=wire error=(unit tang)]
  ^-  (quip effect _timer)
  =/  alarm=sole-effect
    klr+~[[[`%un ~ `%b] txt="Timer went off!"]]
  :_  timer
  [(send-effect alarm)]~
::
++  peer-sole
  |=  path
  ^-  (quip effect _timer)
  =.  consol.sat  [ost.bol *sole-share]
  :_  timer
  [(send-effect (prompt enter))]~
::
++  activate-timer
  |=  t=@da
  ^-  (quip effect _timer)
  ::  Resets the prompt
  ::
  =^  edit  state.consol.sat  (to-sole set+~)
  :_  timer
  :~  [ost.bol %wait /egg-timer t]
      (send-effect det+edit)
  ==
::
++  send-effect
  |=  e=sole-effect
  ^-  effect
  [conn.consol.sat %diff %sole-effect e]
::
++  prompt
  |=  dial=styx
  ^-  sole-effect
  pro+[& %$ dial]
::
++  enter
  ^-  styx
  :~  [[~ ~ ~] " | "]
      [[```%g] "Enter timestamp "]
      [[```%r] "(e.g. 2019.10.14..04.34.46..1435)"]
      [[~ ~ ~] " | "]
  ==
::
++  poke-sole-action
  |=  act=sole-action
  ^-  (quip effect _timer)
  =*  share  state.consol.sat
  ?-    -.act
      ::  %clr: clear screen
      ::
      %clr
    [~ timer]
      ::  %ret: enter key pressed
      ::
      %ret
    ?~  buf.share
      [~ timer]
    ::  %egg (?)
    ::
    =/  egg=(unit @t)
      (rust (tufa buf.share) ;~(just (jest (crip "droids"))))
    ?.  =(~ egg)
      [[(send-effect droids)]~ timer]
    ::  Checks for a date using +crub.
    ::  It also parses @p, @t... so we discard those
    ::
    =/  timestamp=(unit dime)
      (rust (tufa buf.share) crub:so)
    ?~  timestamp
      :_  timer
      [(send-effect txt+"That's not a date!")]~
    ~&  u.timestamp
    ?.  =(%da `@tas`-.u.timestamp)
      :_  timer
      [(send-effect txt+"Only dates please...")]~
    (activate-timer +.u.timestamp)
      ::  %det: key press
      ::  pressed key is stored in the console state
      ::
      %det
    =^  inv  share  (~(transceive ..transceive share) +.act)
    [~ timer]
  ==
::
++  to-sole
  |=  inv=sole-edit
  ^-  [sole-change sole-share]
  (~(transmit ..transmit state.consol.sat) inv)
::
++  droids
  :-  %klr
  :~  :-  [`%un ~ `%b]
      txt="These aren't the Timers you're looking for..."
  ==
--

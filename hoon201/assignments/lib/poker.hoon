::
/+  playing-cards
=,  playing-cards
::
|%
::  position by position comparison of elements in a and b
::
++  compare
  |=  [a=deck b=deck]
  ^-  [tape (unit hand)]
  ::  we convert 1s to 14s
  ::
  =/  a-m=deck  (turn a |=(e=darc ?:(=(val.e 1) [sut.e 14] [sut.e val.e])))
  =/  b-m=deck  (turn b |=(e=darc ?:(=(val.e 1) [sut.e 14] [sut.e val.e])))
  =/  p1=[(list @) hand]  (score a-m)
  =/  p2=[(list @) hand]  (score b-m)
  =*  s1  -.p1
  =*  s2  -.p2
  |-  ^-  [tape (unit hand)]
  ?~  s1  ["It's a tie!" ~]
  ?~  s2  ["It's a tie!" ~]
  ?:  (gth i.s1 i.s2)  ["Player 1 wins!" `+.p1]
  ?:  (lth i.s1 i.s2)  ["Player 2 wins!" `+.p2]
  $(s1 t.s1, s2 t.s2)
::
++  score
  |=  d=deck
  ^-  [(list @) hand]
  =/  h=deck  (sort-hand d)
  ::  we store the list of all values
  ::
  =/  vals=(list @)  (turn h |=(e=darc val.e))
  =/  straight-flush=[darc f=? s=?]
    %+  roll  h
      |=  [e=darc [a=darc f=? s=?]]
      ^-  [darc ? ?]
      ?:  =(val.a 0)  [e & &]
      :+  e
        &(f =(sut.a sut.e))
      &(s =((sub val.a val.e) 1))
  ::
  ?:  f.straight-flush
    ?:  s.straight-flush
      :: straight-flush
      ::
      [(limo [8 (snag 0 vals) ~]) %straight-flush]
    ::  flush
    ::
    [(limo [5 vals]) %flush]
  ?:  s.straight-flush
    :: straight
    ::
    [(limo [4 (snag 0 vals) ~]) %straight]
  ::  checking for 4/3/2-card groupings
  ::
  =/  groups=(jar @ @)
    =|  m=(jar @ suit)
    ::  we group cards by value (e.g. 3 threes, 4 kings...)
    ::
    =-  (extract-groups -)
    ::  by first counting cards and storing them in a jar
    ::
    |-  ^-  (list [@ (list suit)])
    ?~  h  ~(tap by m)
    $(h t.h, m (~(add ja m) val.i.h sut.i.h))
  =/  quads=(list @)  (~(get ja groups) 4)
  =/  trips=(list @)  (~(get ja groups) 3)
  =/  pairs=(list @)  (~(get ja groups) 2)
  =/  lones=(list @)  (~(get ja groups) 1)
  ?^  quads
    ::  four-of-a-kind
    ::
    [(limo [7 (weld quads lones)]) %four-of-a-kind]
  ?^  trips
    ?^  pairs
      ::  full house
      ::
      [(limo [6 (weld trips pairs)]) %full-house]
    ::  three-of-a-kind
    ::
    [(limo [3 (weld trips (sort lones gth))]) %three-of-a-kind]
  ?^  pairs
    ?:  (gth (lent pairs) 1)
      ::  two-pairs
      ::
      [(limo [2 (weld (sort pairs gth) lones)]) %two-pairs]
    ::  one-pair
    ::
    [(limo [1 (weld pairs (sort lones gth))]) %one-pair]
  ::  high-card
  ::
  [(limo [0 vals]) %high-card]
::
++  extract-groups
  |=  m=(list [@ (list suit)])
  ^-  (jar @ @)
  =|  g=(jar @ @)
  |-
  ?~  m  g
  =.  g  (~(add ja g) (lent +.i.m) -.i.m)
  $(m t.m)
::
++  sort-hand
  |=  d=deck
  ^-  deck
  %+  sort  d
    |=  [a=darc b=darc]
    ^-  ?
    !(lte val.a val.b)
--

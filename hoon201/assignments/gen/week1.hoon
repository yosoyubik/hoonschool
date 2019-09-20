::  Week 1:
::    Deal two hands and check which one wins according to poker rules
::
/+  playing-cards
=,  playing-cards
::
!:
::
=<  :-  %say
    |=  [[* eny=@uv *] *]
    :: =/  deck  (shuffle-deck make-deck eny)
    :: =^  first-hand   deck  (draw 5 deck)
    :: =^  second-hand  deck  (draw 5 deck)
    ::  %straight-flush
    :: =/  a=deck  ~[[*suit 2] [*suit 3] [*suit 4] [*suit 5] [*suit 6]]
    :: =/  b=deck  ~[[*suit 6] [*suit 3] [*suit 4] [*suit 5] [*suit 7]]
    ::  %four-of-a-kind
    :: =/  a=deck  ~[[%hearts 12] [%diamonds 12] [%clubs 12] [%spades 12] [%hearts 6]]
    :: =/  b=deck  ~[[%hearts 12] [%diamonds 12] [%clubs 12] [%spades 12] [%hearts 7]]
    ::  %full-house
    :: =/  a=deck  ~[[%hearts 12] [%diamonds 12] [%clubs 12] [%spades 2] [%hearts 2]]
    :: =/  b=deck  ~[[%hearts 1] [%diamonds 1] [%clubs 1] [%spades 12] [%hearts 12]]
    ::  %flush
    :: =/  a=deck  ~[[*suit 4] [*suit 10] [*suit 5] [*suit 6] [*suit 7]]
    :: =/  b=deck  ~[[*suit 6] [*suit 4] [*suit 10] [*suit 5] [*suit 7]]
    ::  %straight
    :: =/  a=deck  ~[[%hearts 2] [*suit 3] [*suit 4] [*suit 5] [*suit 6]]
    :: =/  b=deck  ~[[*suit 7] [*suit 3] [%hearts 4] [*suit 5] [*suit 6]]
    ::  %three-of-a-kind
    :: =/  a=deck  ~[[%hearts 12] [%diamonds 12] [%clubs 12] [%spades 3] [%hearts 2]]
    :: =/  b=deck  ~[[%hearts 1] [%diamonds 1] [%clubs 1] [%spades 12] [%hearts 12]]
    ::  %two-pair
    :: =/  a=deck  ~[[%hearts 12] [%diamonds 12] [%clubs 2] [%spades 3] [%hearts 2]]
    :: =/  b=deck  ~[[%hearts 1] [%diamonds 1] [%clubs 13] [%spades 12] [%hearts 12]]
    ::  %one-pair
    :: =/  a=deck  ~[[%hearts 12] [%diamonds 12] [%clubs 4] [%spades 3] [%hearts 2]]
    :: =/  b=deck  ~[[%hearts 1] [%diamonds 1] [%clubs 13] [%spades 2] [%hearts 12]]
    ::  %high-card
    =/  a=deck  ~[[%hearts 12] [%diamonds 13] [%clubs 4] [%spades 3] [%hearts 2]]
    =/  b=deck  ~[[*suit 6] [*suit 3] [*suit 4] [*suit 5] [*suit 7]]
    :: =/  b=deck  ~[[%hearts 1] [%diamonds 1] [%clubs 13] [%spades 2] [%hearts 12]]
    :-  %noun
    (compare (score a) (score b))
::
=>  |%
    +|  %hands
    +$  hand
      $?  %straight-flush
          %four-of-a-kind
          %full-house
          %flush
          %straight
          %three-of-a-kind
          %two-pair
          %one-pair
          %high-card
      ==
    :: +$  hand  [hand-type rank-attr]
    ::
    +|  %rank-mappings
    +$  hand-rank   (map @ hand)
    +$  hand-value  (map hand @)
    +|  %hand-info
    :: +$  hand-type
    ::   $?  %straight-flush
    ::       %four-of-a-kind
    ::       %full-house
    ::       %flush
    ::       %straight
    ::       %three-of-a-kind
    ::       %two-pair
    ::       %one-pair
    ::       %high-card
    ::   ==
    +$  rank-attr
      $%  [%max @]
          ::  [suit val]
          ::
          [%suits (list [=suit m=@])]
          ::  for high-rank all vals matter
          ::
          [%highs (list @)]
      ==
    ++  ranks
      %-  ~(gas by *hand-rank)
      :~  [0 %straight-flush]
          [1 %four-of-a-kind]
          [2 %full-house]
          [3 %flush]
          [4 %straight]
          [5 %three-of-a-kind]
          [6 %two-pair]
          [7 %one-pair]
          [8 %high-card]
      ==
    ++  values
      %-  ~(gas by *hand-value)
      :~  [%straight-flush 0]
          [%four-of-a-kind 1]
          [%full-house 2]
          [%flush 3]
          [%straight 4]
          [%three-of-a-kind 5]
          [%two-pair 6]
          [%one-pair 7]
          [%high-card 8]
      ==
    --
::
|%
::  position by position comparison of elements in a and b
::
++  compare
  |=  [a=(list @) b=(list @)]
  ~&  compare+[a b]
  :: ?.  =((lent a) (lent b))
  ::   "error: rankings should be of the same length"
  |-
  ?~  a  "it's a tie!"
  ?~  b  "it's a tie!"
  ~&  [i.a i.b]
  ?:  (gth i.a i.b)  "1st hand wins!"
  ?:  (lth i.a i.b)  "2nd hand wins!"
  $(a t.a, b t.b)
::
++  score
  |=  d=deck
  ^-  (list @)
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
    :: =|  s=?  |
    :: =|  f=?  |
    :: =-  ?:(- [s f] [s f])
    :: |-  ^-  ?
    :: ?~  h    &
    :: ?~  t.h  &
    :: ::  checks if cards are of sequential rank
    :: ::
    :: =.  s  =((sub val.i.h val.i.t.h) 1)
    :: ::  checks if all have same suit
    :: ::
    :: =.  f  =(sut.i.h sut.i.t.h)
    :: $(h t.h)
  ::
  ~&  [vals+vals h straight-flush]
  ?:  f.straight-flush
    ?:  s.straight-flush
      :: straight-flush
      ::
      (limo [8 (snag 0 vals) ~])
    ::  flush
    ::
    (limo [5 vals])
  ?:  s.straight-flush
    :: straight
    ::
    (limo [4 (snag 0 vals) ~])
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
  ~&  [quads trips pairs lones]
  ?^  quads
    ::  four-of-a-kind
    ::
    (limo [7 (weld quads lones)])
  ?^  trips
    ?^  pairs
      ::  full house
      ::
      (limo [6 (weld trips pairs)])
    ::  three-of-a-kind
    ::
    (limo [3 (weld trips (sort lones gth))])
  ?^  pairs
    ?:  (gth (lent pairs) 1)
      ::  two-pairs
      ::
      (limo [2 (weld (sort pairs gth) lones)])
    ::  one-pair
    ::
    (limo [1 (weld pairs (sort lones gth))])
  ::  high-card
  ::
  (limo [0 vals])
::
++  extract-groups
  |=  m=(list [@ (list suit)])
  ~&  extract-groups+m
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
:: ::
:: ++  equal-rank
::   |=  [a=deck b=deck =hand]
::   :: |=  [a=(unit rank-attrs) b=(unit rank-attrs) =hand]
::   ^-  tape
::   ?~  a
::     ?~  b  "it's a tie!"
::     "2nd hand wins!"
::   ?~  b  "1st hand wins!"
::   ?:  =(hand %straight-flush)
::     ?:  (gth val.i.a val.i.b)  "1st hand wins!"
::     ?:  =(val.i.a val.i.b)     "it's a tie!"
::     "2nd hand wins!"
::   ?:  =(hand %four-of-a-kind)
::     =|  s=(set @)
::     =|  t=(set @)
::     =-  ?.(- ~ `%four-of-a-kind)
::     |-  ^-  ?
::     ?~  a
::     ?~  b
::     $(a t.a, b t.b, s (~(put in s) val.i.a), t (~(put in t) val.i.b))
::   "TODO"
::   :: ?-    hand
::   :: :: ?-    [-.a -.b]
::   ::   %straight-flush
::   ::   ?:  ?=([@ @] [+.a +.b])
::   ::   :: [%max %max]
::   ::     (compare-max +.a +.b)
::   ::   "wrong hand/attribute combination"
::     :: %straight-flush  (compare-max a b)
::     :: ?:  (gth val.i.a val.i.b)  "1st hand wins!"
::     :: ?:  =(val.i.a val.i.b)     "it's a tie!"
::     :: "2nd hand wins!"
::     ::
::     :: %none  *tape
::     ::   %four-of-a-kind
::     :: *tape
::     :: ?:  (gth val.i.a val.i.b)  "1st hand wins!"
::     :: ?:  =(val.i.a val.i.b)     "it's a tie!"
::     :: "2nd hand wins!"
::     ::
::     ::   %full-house
::     :: *tape
::     ::   %flush
::     :: *tape
::     ::   %straight
::     :: *tape
::     ::   %three-of-a-kind
::     :: *tape
::     ::   %two-pair
::     :: *tape
::     ::   %one-pair
::     :: *tape
::     ::   %high-card
::     :: *tape
::   ==
:: ::
:: :: ++  hand-rank
:: ::   |=  d=deck
:: ::   ^-  hand
:: ::   %-  need
:: ::   =|  r=@
:: ::   |-  ^-  (unit hand)
:: ::   ?:  (gth r 7)
:: ::     `%high-card
:: ::   =-  ?~(- $(r +(r)) -)
:: ::   ?-    (~(got by ranks) r)
:: ::     %straight-flush   (straight-flush d)
:: ::     %four-of-a-kind   (four-of-a-kind d)
:: ::     %full-house       (full-house d)
:: ::     %flush            (flush d)
:: ::     %straight         (straight d)
:: ::     %three-of-a-kind  (three-of-a-kind d)
:: ::     %two-pair         (two-pair d)
:: ::     %one-pair         (one-pair d)
:: ::     %high-card        `%high-card
:: ::   ==
:: ::
:: ++  sort-hand
::   |=  d=deck
::   ^-  deck
::   %+  sort  d
::     |=  [a=darc b=darc]
::     ^-  ?
::     !(lte val.a val.b)
:: ++  five-of-a-kind
::   |=  d=deck
::   d
:: ::
:: ::  A straight flush is a hand that contains five cards of sequential rank,
:: ::  all of the same suit, such as Q♥ J♥ 10♥ 9♥ 8♥
:: ::
:: ++  straight-flush
::   |=  d=deck
::   ^-  (unit hand)
::   =|  max=@
::   =-  ?.(- ~ `%straight-flush)
::   :: =-  ?.(- ~ `[%straight-flush max+max])
::   |-  ^-  ?
::   ?~  d    &
::   ?~  t.d  &
::   ?&  $(d t.d, max (^max val.i.d val.i.t.d))
::       ::  checks if all have same suit
::       ::
::       =(sut.i.d sut.i.t.d)
::       ::  checks if cards are of sequential rank
::       ::
::       =((sub val.i.d val.i.t.d) 1)
::   ==
:: ::
:: ::  A hand that contains four cards of one rank and one card of another rank
:: ::
:: ++  four-of-a-kind
::   |=  d=deck
::   ^-  (unit hand)
::   =|  s=(set @)
::   =-  ?.(- ~ `%four-of-a-kind)
::   :: =-  ?.(- ~ `[%four-of-a-kind suits+~[[*suit *@] [*suit *@]]])
::   |-  ^-  ?
::   ?~  d  =(~(wyt in s) 2)
::   $(d t.d, s (~(put in s) val.i.d))
:: ++  full-house
::   |=  d=deck
::   ^-  (unit hand)
::   ~
:: ++  flush
::   |=  d=deck
::   ^-  (unit hand)
::   ~
:: ++  straight
::   |=  d=deck
::   ^-  (unit hand)
::   ~
:: ++  three-of-a-kind
::   |=  d=deck
::   ^-  (unit hand)
::   ~
:: ++  two-pair
::   |=  d=deck
::   ^-  (unit hand)
::   ~
:: ++  one-pair
::   |=  d=deck
::   ^-  (unit hand)
::   ~
--
::

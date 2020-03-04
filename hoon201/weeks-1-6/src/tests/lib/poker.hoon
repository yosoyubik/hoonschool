/+  *test, playing-cards, poker, hands
::
=,  poker
=,  playing-cards
=,  hands
::
|%
++  test-random-hands
  ;:  weld
    %+  expect-eq
      !>  670
      !>  (lent hands)
    ::
    =/  wins=@
      %+  roll  (limo hands)
        |=  [players=deck wins=@]
        =/  a=deck  (scag 5 players)
        =/  b=deck  (slag 5 players)
        ?:  =("Player 1 wins!" -:(compare a b))
          +(wins)
        wins
    %+  expect-eq
      !>  240
      !>  wins
  ==
::
++  test-straight-flush
  =/  a=deck  ~[[%spades 10] [%spades 7] [%spades 9] [%spades 8] [%spades 6]]
  =/  b=deck  ~[[%hearts 8] [%hearts 6] [%hearts 7] [%hearts 5] [%hearts 4]]
  =/  r-f=deck  ~[[%spades 1] [%spades 13] [%spades 12] [%spades 11] [%spades 10]]
  =/  s-w=deck  ~[[%hearts 1] [%hearts 2] [%hearts 3] [%hearts 4] [%hearts 5]]
  ;:  weld
    %+  expect-eq
      !>  ["Player 1 wins!" `%straight-flush]
      !>  (compare a b)
    %+  expect-eq
      !>  ["Player 1 wins!" `%straight-flush]
      !>  (compare r-f a)
    %+  expect-eq
      !>  ["Player 2 wins!" `%straight-flush]
      !>  (compare s-w a)
    %+  expect-eq
      !>  ["Player 2 wins!" `%straight-flush]
      !>  (compare s-w b)
  ==
::
++  test-four-of-a-kind
  =/  a=deck
    ~[[%hearts 12] [%diamonds 12] [%clubs 12] [%spades 12] [%hearts 6]]
  =/  b=deck
    ~[[%spades 11] [%diamonds 11] [%clubs 11] [%spades 9] [%hearts 7]]
  %+  expect-eq
    !>  ["Player 1 wins!" `%four-of-a-kind]
    !>  (compare a b)
::
++  test-full-house
  =/  a=deck
    ~[[%hearts 12] [%diamonds 12] [%clubs 12] [%spades 2] [%hearts 2]]
  =/  b=deck
    ~[[%hearts 1] [%diamonds 1] [%clubs 1] [%spades 11] [%hearts 11]]
  %+  expect-eq
    !>  ["Player 2 wins!" `%full-house]
    !>  (compare a b)
::
++  test-flush
  =/  a=deck  ~[[%hearts 4] [%hearts 10] [%hearts 5] [%hearts 6] [%hearts 7]]
  =/  b=deck  ~[[%diamonds 6] [%diamonds 4] [%diamonds 10] [%diamonds 5] [%diamonds 7]]
  %+  expect-eq
    !>  ["It's a tie!" ~]
    !>  (compare a b)
::
++  test-straight
  =/  a=deck    ~[[%hearts 2] [%spades 3] [%spades 4] [%diamonds 5] [%diamonds 6]]
  =/  b=deck    ~[[%diamonds 7] [%hearts 3] [%hearts 4] [%spades 5] [%spades 6]]
  =/  b-s=deck  ~[[%hearts 1] [%diamonds 2] [%diamonds 3] [%diamonds 4] [%hearts 5]]
  ;:  weld
    %+  expect-eq
      !>  ["Player 2 wins!" `%straight]
      !>  (compare a b)
    %+  expect-eq
      !>  ["Player 1 wins!" `%straight]
      !>  (compare a b-s)
    %+  expect-eq
      !>  ["Player 1 wins!" `%straight]
      !>  (compare b b-s)
  ==
::
++  test-three-of-a-kind
  =/  a=deck
    ~[[%hearts 12] [%diamonds 12] [%clubs 12] [%spades 3] [%hearts 2]]
  =/  b=deck
    ~[[%hearts 1] [%diamonds 1] [%clubs 1] [%spades 2] [%spades 12]]
  %+  expect-eq
    !>  ["Player 2 wins!" `%three-of-a-kind]
    !>  (compare a b)
::
++  test-two-pairs
  =/  a=deck
    ~[[%hearts 12] [%diamonds 12] [%clubs 2] [%spades 3] [%hearts 2]]
  =/  b=deck
    ~[[%hearts 1] [%diamonds 1] [%clubs 13] [%spades 12] [%clubs 12]]
  %+  expect-eq
    !>  ["Player 2 wins!" `%two-pairs]
    !>  (compare a b)
::
++  test-one-pair
  =/  a=deck
    ~[[%hearts 12] [%diamonds 12] [%clubs 4] [%spades 3] [%hearts 2]]
  =/  b=deck
    ~[[%hearts 1] [%diamonds 1] [%clubs 13] [%spades 2] [%hearts 12]]
  %+  expect-eq
    !>  ["Player 2 wins!" `%one-pair]
    !>  (compare a b)
::
++  test-high-card
  =/  a=deck
    ~[[%hearts 12] [%diamonds 13] [%clubs 4] [%spades 3] [%hearts 2]]
  =/  b=deck
    ~[[%hearts 13] [%diamonds 10] [%clubs 3] [%spades 1] [%hearts 4]]
  %+  expect-eq
    !>  ["Player 2 wins!" `%high-card]
    !>  (compare a b)
--

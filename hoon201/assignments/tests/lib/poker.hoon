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
        ?:  =("Player 1 wins!" (compare a b))
          +(wins)
        wins
    %+  expect-eq
      !>  240
      !>  wins
  ==
::
++  test-straight-flush
  =/  a=deck  ~[[*suit 2] [*suit 3] [*suit 4] [*suit 5] [*suit 6]]
  =/  b=deck  ~[[*suit 6] [*suit 3] [*suit 4] [*suit 5] [*suit 7]]
  %+  expect-eq
    !>  "Player 2 wins!"
    !>  (compare a b)
::
++  test-four-of-a-kind
  =/  a=deck
    ~[[%hearts 12] [%diamonds 12] [%clubs 12] [%spades 12] [%hearts 6]]
  =/  b=deck
    ~[[%hearts 12] [%diamonds 12] [%clubs 12] [%spades 12] [%hearts 7]]
  %+  expect-eq
    !>  "Player 2 wins!"
    !>  (compare a b)
::
++  test-full-house
  =/  a=deck
    ~[[%hearts 12] [%diamonds 12] [%clubs 12] [%spades 2] [%hearts 2]]
  =/  b=deck
    ~[[%hearts 1] [%diamonds 1] [%clubs 1] [%spades 12] [%hearts 12]]
  %+  expect-eq
    !>  "Player 2 wins!"
    !>  (compare a b)
::
++  test-flush
  =/  a=deck  ~[[*suit 4] [*suit 10] [*suit 5] [*suit 6] [*suit 7]]
  =/  b=deck  ~[[*suit 6] [*suit 4] [*suit 10] [*suit 5] [*suit 7]]
  %+  expect-eq
    !>  "It's a tie!"
    !>  (compare a b)
::
++  test-straight
  =/  a=deck  ~[[%hearts 2] [*suit 3] [*suit 4] [*suit 5] [*suit 6]]
  =/  b=deck  ~[[*suit 7] [*suit 3] [%hearts 4] [*suit 5] [*suit 6]]
  %+  expect-eq
    !>  "Player 2 wins!"
    !>  (compare a b)
::
++  test-three-of-a-kind
  =/  a=deck
    ~[[%hearts 12] [%diamonds 12] [%clubs 12] [%spades 3] [%hearts 2]]
  =/  b=deck
    ~[[%hearts 1] [%diamonds 1] [%clubs 1] [%spades 2] [%hearts 12]]
  %+  expect-eq
    !>  "Player 2 wins!"
    !>  (compare a b)
::
++  test-two-pair
  =/  a=deck
    ~[[%hearts 12] [%diamonds 12] [%clubs 2] [%spades 3] [%hearts 2]]
  =/  b=deck
    ~[[%hearts 1] [%diamonds 1] [%clubs 13] [%spades 12] [%hearts 12]]
  %+  expect-eq
    !>  "Player 2 wins!"
    !>  (compare a b)
::
++  test-one-pair
  =/  a=deck
    ~[[%hearts 12] [%diamonds 12] [%clubs 4] [%spades 3] [%hearts 2]]
  =/  b=deck
    ~[[%hearts 1] [%diamonds 1] [%clubs 13] [%spades 2] [%hearts 12]]
  %+  expect-eq
    !>  "Player 2 wins!"
    !>  (compare a b)
::
++  test-high-card
  =/  a=deck
    ~[[%hearts 12] [%diamonds 13] [%clubs 4] [%spades 3] [%hearts 2]]
  =/  b=deck
    ~[[%hearts 12] [%diamonds 13] [%clubs 3] [%spades 1] [%hearts 2]]
  %+  expect-eq
    !>  "Player 2 wins!"
    !>  (compare a b)
::
--

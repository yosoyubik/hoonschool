::  week6
::
::  Write a %say generator that takes two arguments x and y and produces a list
::  of x lists of y cards from a standard 52 card deck
::
/?    310
::
:-  %say
|=  [[* eny=@ *] [x=@ y=@ ~] ~]
=<  ::  %baraja is pushed in the subject & innitialized/shuffled
    ::
    =/  baraja  barajar:baraja
    :-  %noun
    |-  ^-  (list (list carta))
    ?:  =(0 x)  ~
    =^  hand  baraja  (repartir:baraja y)
    [hand $(x (dec x))]
::
=>  |%
    +|  %types
    +$  palo   $?  %oros  %copas  %espadas  %bastos
               ==
    ::
    +$  naipe  $?  %as     %dos   %tres   %cuatro  %cinco    %seis
                    %siete  %ocho  %nueve  %sota    %caballo  %rey
                ==
    ::
    +$  carta  [=palo =naipe]
    --
::
|%
+|  %engine
++  baraja
  |_  [cartas=(list carta)]
  ++  this  .
  ++  palos   ~[%copas %espadas %bastos %oros]
  ++  naipes  :~  %as     %dos   %tres   %cuatro  %cinco    %seis
                  %siete  %ocho  %nueve  %sota    %caballo  %rey
              ==
  ::
  ::  (naive) innitializer of the %cartas of %baraja (i.e. deck)
  ::
  ++  init
    =|  cartos=(list carta)
    =/  p=(list palo)  palos
    |-  ^-  (list carta)
    ?~  p
      cartos
    =/  n=(list naipe)  naipes
    |-  ^-  (list carta)
    ?~  n
      ^$(p t.p)
    [[i.p i.n] $(n t.n)]
  ::
  ::  %barajar: randomizes the deck of cards (i.e. shuffle)
  ::
  ++  barajar
    ^-  _this
    :: TODO: Randomize the deck
    ::
    this(cartas init)
  ::
  ::  %repartir: hands out %num cards.
  ::  updates %cartas samples removing the %naipes that have been handed out.
  ::
  ++  repartir
    |=  num=@
    ^-  (quip carta _this)
    =|  hand=(list carta)
    |-
    ?~  cartas  [hand this]
    ?:  =(num 0)  [hand this]
    %=  $
      hand  [i.cartas hand]
      cartas  t.cartas
      num  (dec num)
    ==
  --
--

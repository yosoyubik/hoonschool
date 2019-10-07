::  Week 2:
::    Write “+turn” w/o stdlib
::
::  Tests are included in the generator for easier checking the correctness
::  behavior of the assignment. If all tests pass, not output will be displayed.
::  Failing tests will show an output of the format:
::
::  > +week3
::  expected: [i=3 t=[i=7 t=[i=9 t=[i=13 t=[i=0 t=~]]]]]
::  actual: ~[3 7 9 13]
::  expected: [i=3 t=[i=3 t=[i=4 t=[i=6 t=[i=5 t=[i=4 t=[i=0 t=~]]]]]]]
::  actual: ~[3 3 4 6 5 4]
::
/+  *test
::
!:
::
=<  :-  %say
    |=  [[* eny=@uv *] *]
    =/  lista=(list @)  (gulf 1 7)
    =/  listb=(list [@ @])  ~[[1 2] [3 4] [4 5] [6 7]]
    =/  listc=(list tape)   ~["uno" "dos" "tres" "cuatro" "cinco" "seis"]
    =/  listd=(list cord)   ~['uno' 'dos' 'tres' 'cuatro' 'cinco' 'seis']
    :-  %tang
    %-  flop
    ;:  weld
      %+  expect-eq
        !>  (gulf 0 6)
        !>  (turno lista dec)
      %+  expect-eq
        !>  (limo ~[3 7 9 13])
        !>  %+  turno  listb
              |=  [a=@ b=@]
              (add a b)
      %+  expect-eq
        !>  (limo ~[3 3 4 6 5 4])
        !>  (turno listc lent)
      %+  expect-eq
        !>  %-  limo
            :~  (dec 'uno')
                (dec 'dos')
                (dec 'tres')
                (dec 'cuatro')
                (dec 'cinco')
                (dec 'seis')
            ==
        !>  (turno listd dec)
      %+  expect-eq
        !>  ^-  (list cord)
            :~  (dec 'uno')
                (dec 'dos')
                (dec 'tres')
                (dec 'cuatro')
                (dec 'cinco')
                (dec 'seis')
            ==
        !>  %+  turno  listd
              |=  a=cord
              `cord`(dec a)
    ==
::
|%
++  turno
  |*  [l=(list) g=$-(* *)]
  =<  $
  ::  We force a cast to a type list, where the element
  ::  of the list is normalized by an example of the product
  ::  of using the gate `g` on the first element of the list
  ::
  |.  ^-  (list _?>(?=(^ l) (g i.l)))
  ?~  l  ~
  ::  Faces (i, t) of lists are not used here since the
  ::  cast will normalize the product of the trap.
  ::
  ::  If the faces were to be accessed within the trap, this
  ::  would fail due to the faces being not present.
  ::
  [(g i.l) $(l t.l)]
--

::  Week 2:
::    Write “+turn” w/o stdlib
::
!:
::
=<  :-  %say
    |=  [[* eny=@uv *] *]
    =/  lista=(list @)  (gulf 1 7)
    =/  listb=(list [@ @])  ~[[1 2] [3 4] [4 5] [6 7]]
    =/  listc=(list tape)  ~["uno" "dos" "tres" "cuatro" "cinco" "seis"]
    =/  listd=(list cord)  ~['uno' 'dos' 'tres' 'cuatro' 'cinco' 'seis']
    :-  %noun
    :~  !>((turno lista dec))
        !>  %+  turno  listb
          |=  [a=@ b=@]
          (add a b)
        !>((turno listc lent))
        !>((turno listd dec))
        !>  %+  turno  listd
          |=  a=cord
          ^-  cord
          (dec a)
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
  ::  We use the gate on the first element of the list
  ::  Faces (i, t) of lists are not used here since the
  ::  cast will normalize the product of the trap.
  ::
  ::  If the faces were to be accessed within the trap, this
  ::  would fail due to the faces being not present.
  ::
  [(g i.l) $(l t.l)]
--

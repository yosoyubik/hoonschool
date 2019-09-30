::  Week 2:
::    Write a depth-first search of a tree
::    https://en.wikipedia.org/wiki/Depth-first_search
::::
!:
::
=<  :-  %say
    |=  [[* eny=@uv *] *]
    =/  d=deck  (shuffle-deck make-deck eny)
    =^  a=deck  d  (draw 5 d)
    =^  b=deck  d  (draw 5 d)
    :-  %noun
    [(dfs a b) a^b]
::
=>  :: Type declarations
    ::
    |%
    ++  tree
      |$  [item]
      $@(~ [n=item l=(tree item) r=(tree item)])
    ::
    ::  A dictionary stores words (represented as cords) that
    ::  we might find when learning a new language and whose
    ::  meaning we don't know yet, but we want to remember.
    ::  For example: in Danish the words 'mor' and 'mord' are
    ::  spelled different but pronounced similarly by a non-native
    ::  speaker not accustomed to the glottal-stop.
    ::
    ++  dictionary  (tree cord)
    --
::
|%
++  search
  ::  Map door with a DFS gate in it
  ::
  |_  d=dictionary
  ::
  ::  Innitializes the map with a provided text represented as a tape
  ::
  ++  innit
    ^+  d
    :+  1
      l=[2 [3 [4 ~ ~] [5 ~ ~]] [6 ~ ~]]
    r=[8 [9 [10 ~ ~] [11 ~ ~]] [8 ~ ~]]
  ::
  ::  Implementation of a DFS algorithm
  ::
  ++  dfs
  --
--
::

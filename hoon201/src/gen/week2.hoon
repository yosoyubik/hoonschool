::  Week 2:
::    Write a depth-first search of a tree
::    https://en.wikipedia.org/wiki/Depth-first_search
::
!:
::
=<  :-  %say
    |=  [[* eny=@uv *] *]
    =/  =nuclear-tree  innit:dfs
    :-  %noun
    :*  traverse+~(traverse dfs nuclear-tree)
        search-1+(~(search dfs nuclear-tree) 1)
        search-8+(~(search dfs nuclear-tree) 8)
        search-0+(~(search dfs nuclear-tree) 0)
        search-99+(~(search dfs nuclear-tree) 99)
    ==
::
=>  :: Type declarations
    ::
    |%
    +*  tree  [item]
      $@(~ [n=item l=(tree item) r=(tree item)])
    ::
    :: A tree of atoms
    ::
    ++  nuclear-tree
      ::  Atoms stored as a binary tree
      ::
      (tree atom)
    --
::
|%
++  dfs
  ::  Map door with a DFS gate in it
  ::
  |_  nt=nuclear-tree
  ::
  ::  Innitializes the map with a provided text represented as a tape
  ::
  ++  innit
    ^+  nt
    ::          1
    ::       /    \
    ::      2      7
    ::     / \    / \
    ::    3   6  8   11
    ::  /  \    /  \
    :: 4   5   9  10
    ::
    :+  1
      l=[2 [3 [4 ~ ~] [5 ~ ~]] [6 ~ ~]]
    r=[7 [8 [9 ~ ~] [10 ~ ~]] [11 ~ ~]]
  ::
  ::  Implementation of a DFS traversal algorithm
  ::  to shows the order in which the nodes are visited
  ::
  ++  traverse
    |-  ^-  (list @)
    ?~  nt  ~
    ;:  weld
      ~[n.nt]
      $(nt l.nt)  $(nt r.nt)
    ==
  ::
  ::  Implementation of a DFS search algorithm
  ::
  ++  search
    |=  e=@
    |-  ^-  ?
    ?~  nt  %.n
    ?:  =(e n.nt)  %.y
    |($(nt l.nt) $(nt r.nt))
  --
--
::

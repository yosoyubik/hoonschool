::  Week 5:
::  Build a gall app that queries a json API of your choosing
::  (or https://pokeapi.co/ if you don't want to pick) and maintains a
::  local copy for any queried data.
::
::  Queries the Poke API with Pokemons and
::  stores them in you Pokedex
::
::  Usage:
::    *  Print Pokedex
::       > :week5 &noun ['print' ~]
::
::   *  Add Pokemon to the Pokedex and print it
::      > :week5 &noun ['fetch' (some 'pikachu')]
::      >=
::      'drumroll please...'
::      [ 'Pokedex: '
::        ~[
::          [ name='charmander'
::            experience=62
::            height=6
::            weight=85
::            abilities=<|solar-power blaze|>
::          ]
::          [ name='pikachu'
::            experience=112
::            height=4
::            weight=60
::            abilities=<|lightning-rod static|>
::          ]
::        ]
::      ]
::
/+  tapp, stdio
::
::  Preamble
::
=>
  |%
  +$  state
    $:  pokedex=(list pokemon)
    ==
  +$  pokemon
    $:  name=@t
        experience=@ud
        height=@ud
        weight=@ud
        abilities=(list cord)
    ==
  +$  peek-data  _!!
  +$  in-poke-data   [%noun [=cord crit=(unit cord)]]
  +$  out-poke-data  ~
  +$  in-peer-data   ~
  +$  out-peer-data
    $%  [%pokedex (list pokemon)]
    ==
  ++  tapp   (^tapp state peek-data in-poke-data out-poke-data in-peer-data out-peer-data)
  ++  stdio  (^stdio out-poke-data out-peer-data)
  --
=>
  |%
  ::
  ::  PokeAPI URL
  ::
  ++  url  "https://pokeapi.co/api/v2/pokemon/"
  --
=,  async=async:tapp
=,  tapp-async=tapp-async:tapp
=,  stdio
=,  dejs-soft:format
::
::  The app
::
%-  create-tapp-poke-peer-take:tapp
^-  tapp-core-poke-peer-take:tapp
|_  [=bowl:gall state]
::
::  Main function
::
++  handle-poke
  |=  =in-poke-data
  =/  m  tapp-async
  ^-  form:m
  ::
  ::  If requested to print, just print what we have in our state
  ::
  ?:  =(cord.in-poke-data 'print')
    ~&  'drumroll please...'
    ;<  now=@da  bind:m  get-time
    ;<  ~        bind:m  (wait (add now ~s3))
    ~&  ['Pokedex: ' pokedex]
    ::  Nothing to see here...
    ::
    (pure:m pokedex)
  ::
  ::  Fetch Pokemon
  ::
  ?~  crit.in-poke-data  (pure:m pokedex)
  ~&  "fetching pokemon #{(trip u.crit.in-poke-data)}"
  =/  poke-url=tape  (weld url (scow %tas u.crit.in-poke-data))
  ~&  poke-url
  ;<  response=json  bind:m  (fetch-json poke-url)
  =/  poke=(unit pokemon)
    %.  response
    =-  (ot -)
    :~  ['name' so]
        ['base_experience' ni]
        ['height' ni]
        ['weight' ni]
        :-  'abilities'
        =-  (ar -)
        =-  (ot ['ability' -]~)
        (ot ['name' so]~)
    ==
  ?~  poke
    ::  Response couldn't be parsed
    ::
    (pure:m pokedex)
  ::  Adds pokemons to the pokedex
  ::
  =.  pokedex  (snoc pokedex u.poke)
  :: And then print
  ::
  ;<  ~  bind:m  (give-result /pokedex %pokedex pokedex)
  (handle-poke %noun 'print' ~)
::
++  handle-peer
  |=  =path
  =/  m  tapp-async
  ^-  form:m
  ~&  [%tapp-fetch-take-peer path]
  (pure:m pokedex)
::
++  handle-take
  |=  =sign:tapp
  =/  m  tapp-async
  ^-  form:m
  ::  ignore %poke/peer acknowledgements
  ::
  ?.  ?=(%wake -.sign)
    (pure:m pokedex)
  ;<  =state  bind:m  (handle-poke %noun 'fetch' ~)
  =.  pokedex  state
  (pure:m pokedex)
--

::  Sticky Notes
::
/-  sole
/+  sole, *server
::
:: This imports the tile's JS file from the file system as a variable.
::
/=  tile-js
  /^  octs
  /;  as-octs:mimes:html
  /:  /===/app/notes/js/tile
  /|  /js/
      /~  ~
  ==
::
=,  format
=,  sole
::
=>  |%
    ::
    +|  %models
    ::
    +$  state
      $:  notes=(list tape)
          ::  $consol: console state
          ::
          ::     $conn:  id for console connection
          ::     $state: data in the console
          ::
          consol=[conn=bone state=sole-share]
      ==
    ::
    +$  move  (pair bone card)
    ::
    +$  card
      $%  [%diff diff-data]
          [%peer wire dock path]
          [%pull wire dock ~]
          [%wait wire p=@dr]
          [%http-response =http-event:http]
          [%connect wire binding:eyre term]
          [%poke wire dock poke-data]
      ==
    ::
    +$  diff-data
      $%  [%sole-effect sole-effect]
          [%json json]
       ==
     ::
     +$  poke-data
       $%  [%launch-action [@tas path @t]]
       ==
    --
::
::  %app
::
::    Our app is defined as a "door" (multi-armed core with a sample).
::    Arms are grouped in chapters (+|) based on common functionality
::
|_  [bol=bowl:gall %0 sat=state]
::
::  %alias: rewording of commonly used nouns
::
+|  %alias
::
::  %this: common idiom to refer to our whole %app door and its context
::
++  this  .
::
::  Aliasing arms declared within cores (requiered by gall)
::
++  poke-sole-action          poke-sole-action:co:view
++  peer-sole-action          peer-sole-action:co:view
++  peer-sole                 peer-sole:co:view
++  peer-notestile            peer-notestile:fe:view
++  poke-json                 poke-json:fe:view
++  bound                     bound:fe:view
++  poke-handle-http-request  poke-handle-http-request:fe:view
::
::  %state
::
::    Arms to innitialize (and restart) our app's state
::
+|  %state
::
++  prep
  =>  |%
      ++  states
        $%  [%0 s=state]
        ==
      --
  |=  old=(unit states)
  ^-  (quip move _this)
  =/  launcha=poke-data
    [%launch-action [%notes /notestile '/~notes/js/tile.js']]
  =/  moves=(list move)
    :~  :: %connect here tells %eyre to mount at the /~notes endpoint.
        ::
        [ost.bol %connect / [~ /'~notes'] %notes]
        [ost.bol %poke /notes [our.bol %launch] launcha]
    ==
  ?~  old
    ::  we haven't modified the previous state
    ::
    [moves this(notes.sat ~)]
  ::  the old state needs to be adapted to the new one
  ::
  ?-  -.u.old
    %0  [~ this(sat s.u.old)]
  ==
::
+|  %engine
::  %add-note: adds a new note
::
++  add-note
  |=  n=tape
  ^-  (quip move _this)
  =^  edit  state.consol.sat  (to-sole:co:view set+~)
  :_  this(notes.sat (snoc notes.sat n))
  :~  (send:co:view mor+~[det+edit txt+"Note added..."])
      %-  send:fe:view
        ['note' s+(crip n)]~
  ==
::
++  json-notes
  ^-  (list [@t json])
  :_  ~
  :-  'notes'
  :-  %a
  %+  turn  notes.sat
  |=  n=tape
  s+(crip n)
::
+|  %view
::  %view
::
::    Arms for displaying notes on the console and frontend
::
++  view
  |%
  ::
  ::  %fe: frontend
  ::
  ::    arms that deal with communication with eyre and the frontend
  ::
  ++  fe
    |%
    ::
    ++  bound
      |=  [wir=wire success=? binding=binding:eyre]
      ^-  (quip move _this)
      [~ this]
    ::
    ::  $peer-notesfile:
    ::
    ++  peer-notestile
      |=  wir=wire
      ^-  (quip move _this)
      :_  this
      [ost.bol %diff %json *json]~
    ::
    ::  +poke-handle-http-request:
    ::
    ::    serve pages from file system based on URl path
    ::
    ++  poke-handle-http-request
      %-  (require-authorization:app ost.bol move this)
        |=  =inbound-request:eyre
        ^-  (quip move _this)
        =/  request-line  (parse-request-line url.request.inbound-request)
        =/  back-path  (flop site.request-line)
        =/  name=@t
          =/  back-path  (flop site.request-line)
          ?~  back-path
            ''
          i.back-path
        ::
        :_  this
        :_  ~
        :+  ost.bol  %http-response
        ?~  back-path
          not-found:app
        ?:  =(name 'tile')
          (js-response:app tile-js)
        not-found:app
    ::
    ++  poke-json
      |=  jon=json
      ^-  (quip move _this)
      ?.  ?=(%o -.jon)
        ::  ignores non-object json
        ::
        [~ this]
      =/  object=(map @t json)  +.jon
      =/  data=json  (~(got by object) 'data')
      ?+    -.data  !!
          %s
        ::  Receive a new note from the frontend and add it
        ::
        =/  note=tape  (trip (so:dejs data))
        :_  this(notes.sat (snoc notes.sat note))
        :_  ~
        %-  send:co:view
          klr+[[[```%b] " Note added from frontend "] ~]
      ::
          %b
        ::  Request to load existing nodes onto the frontend
        ::
        :_  this
        ?.  (bo:dejs data)  ~
        [(send json-notes)]~
      ==
    ::
    ::  +send:
    ::
    ::    sends new data to the frontend
    ::
    ++  send
      |=  pairs=(list [@t json])
      ^-  move
      =-  (snag 0 -)
      %+  turn  (prey:pubsub:userlib /notestile bol)
        |=  [=bone ^]
        [bone %diff %json (pairs:enjs:format pairs)]
    --
  ::
  ::  %co: console
  ::
  ::    %sole arms to receive console moves and prompt formatting
  ::
  ++  co
    |%
    ++  peer-sole
      |=  path
      ^-  (quip move _this)
      =.  consol.sat  [ost.bol *sole-share]
      :_  this
      [(send (prompt enter))]~
    ::
    ++  send
      |=  e=sole-effect
      ^-  move
      [conn.consol.sat %diff %sole-effect e]
    ::
    ++  prompt
      |=  dial=styx
      ^-  sole-effect
      pro+[& %$ dial]
    ::
    ++  enter
      ^-  styx
      :~  [[~ ~ ~] " | "]
          [[```%g] "Type note "]
          [[```%b] "[l shows all notes] "]
          [[~ ~ ~] "| "]
      ==
    ::
    ++  poke-sole-action
      |=  act=sole-action
      ^-  (quip move _this)
      ?.  =(conn.consol.sat ost.bol)  ~|(%strange-sole !!)
      =*  share  state.consol.sat
      ?+    -.act  [~ this]
          ::  %clr: clear screen
          ::
          %clr
        [~ this]
      ::
          ::  %ret: enter key pressed
          ::
          %ret
        ?~  buf.share
          [~ this]
        =/   l=(unit @t)
          (rust (tufa buf.share) ;~(just (just 'l')))
        ?.  =(~ l)  list-notes
        (add-note (tufa buf.share))
      ::
          ::  %det: key press
          ::  pressed key is stored in the console state
          ::
          %det
        (edit-sole +.act)
      ==
    ::
    ++  list-notes
      ^-  (quip move _this)
      =^  edit  state.consol.sat  (to-sole set+~)
      :_  this
      :_  ~
      (send mor+~[det+edit print-notes])
    ::
    ++  print-notes
      =/  c  1
      ^-  sole-effect
      :-  %tan
      %-  flop
        :-  leaf+"....Sticky Notes...."
        |-  ^-  (list [%leaf tape])
        ?~  notes.sat
          ~[leaf+"...................."]
        :-  leaf+"{<c>}. {i.notes.sat}"
        $(notes.sat t.notes.sat, c +(c))
    ::
    ++  to-sole
      |=  inv=sole-edit
      ^-  [sole-change sole-share]
      (~(transmit ..transmit state.consol.sat) inv)
    ::
    ++  edit-sole
      |=  cal=sole-change
      ^-  (quip move _this)
      =^  edit  state.consol.sat
        (~(transceive ..transceive state.consol.sat) cal)
      [~ this]
    --
  --

--

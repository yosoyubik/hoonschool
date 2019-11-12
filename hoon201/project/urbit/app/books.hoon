::  Sticky books
::
/-  sole
/+  unfurl, sole, *server
::
:: This imports the tile's JS file from the file system as a variable.
::
/=  tile-js
  /^  octs
  /;  as-octs:mimes:html
  /:  /===/app/books/js/tile
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
      $:  ::books=(list book)
          ::  Dictionary of URLs -> book
          ::
          books=(map @t book)
          ::  $consol: console state
          ::
          ::     $conn:  id for console connection
          ::     $state: data in the console
          ::
          consol=[conn=bone state=sole-share]
      ==
    ::
    +$  book
      $:  url=tape
          title=cord
          current-price=(unit @rs)
          wished-price=@rs
      ==
    +$  move  (pair bone card)
    ::
    +$  card
      $%  [%diff diff-data]
          [%peer wire dock path]
          [%pull wire dock ~]
          [%wait wire p=@da]
          [%http-response =http-event:http]
          [%connect wire binding:eyre term]
          [%request wire request:http outbound-config:iris]
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
++  peer-bookstile            peer-bookstile:fe:view
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
    [%launch-action [%books /bookstile '/~books/js/tile.js']]
  =/  moves=(list move)
    :~  :: %connect here tells %eyre to mount at the /~books endpoint.
        ::
        [ost.bol %connect / [~ /'~books'] %books]
        [ost.bol %poke /books [our.bol %launch] launcha]
        ::  Activates timer (checks again every hour)
        ::
        [ost.bol %wait /innit (add now.bol ~m2)]
    ==
  ?~  old
    ::  we haven't modified the previous state
    ::
    [moves this(books.sat ~)]
  ::  the old state needs to be adapted to the new one
  ::
  ?-  -.u.old
    %0  [~ this(sat s.u.old)]
  ==
::
+|  %engine
::  %add-book: adds a new book
::
++  add-book
  |=  b=[@rs tape]
  ^-  (quip move _this)
  =^  edit  state.consol.sat  (to-sole:co:view set+~)
  =/  book-id=@t  (parse-amazon-url +.b)
  ~&  book-id
  =/  =book  [+.b *@t `*@rs -.b]
  :_  this(books.sat (~(put by books.sat) [book-id book]))
  %+  weld
    ::  Console notification
    ::
    :_  ~
    %-  send:co:view
      mor+~[det+edit txt+"Book added..."]
    ::  Parse Amazon URL
    ::
    (request-amazon-page (scan url.book auri:de-purl:html))
::
++  request-amazon-page
  |=  u=purl:eyre
  ^-  (list move)
  =/  hed  [['Accept' 'text/html']]~
  =/  url=@t  (crip (en-purl:html u))
  =/  req=request:http  [%'GET' url hed *(unit octs)]
  =/  out  *outbound-config:iris
  =/  id  %+  scot  %ud
    (parse-amazon-url (en-purl:html u))
  [ost.bol %request /[(scot %da now.bol)]/[id] req out]~
::
++  doctype
  ;~(pfix (jest '<!doctype html>') (more (just '\0a') (star prn)))
::
++  parse-amazon-url
  |=  amazon-url=tape
  =,  string:unfurl
  ^-  cord
  =/  offer-tape  "offer-listing/"
  =/  offer-i=(unit @ud)
    (find offer-tape amazon-url)
  ?~  offer-i  *cord
  =/  listing-el=tape
    %^  get  amazon-url
     u.offer-i
     (lent amazon-url)
  %-  crip
  %^  get  listing-el
    (lent offer-tape)
    (lent amazon-url)
::
++  parse-amazon-page
  =<  |=(html=tape (apex html))
  =,  string:unfurl
  |%
  ++  apex
    |=  =html=tape
    ^-  [@rs @t @t]
    =/  h1-title=tape
      (extract-title-header html-tape)
    =/  row-price=tape
      (extract-price-row html-tape)
    =/  h1-title-node=(unit manx)
      (de-xml:html (crip h1-title))
    =/  row-price-node=(unit manx)
      (de-xml:html (crip row-price))
    :+
    ?~  row-price-node  *@rs
    (extract-price-text u.row-price-node)
    ?~  h1-title-node  *@t
      (extract-title-text u.h1-title-node)
    (extract-listing-id html-tape)
  ::
  ++  extract-listing-id
    |=  html=tape
    ^-  cord
    =/  init-listing  "\"path\":\"/gp/offer-listing/"
    =/  listing-i=@ud
      %-  need
      (find init-listing html)
    =/  listing-el=tape
      (get html listing-i (lent html))
    =/  listing-end=@ud
      %-  need
      (find "\",\"isAUI\":" listing-el)
    %-  crip
    %^  get  listing-el
      (lent init-listing)
      listing-end
  ::
  ++  extract-title-text
    |=  title-node=manx
    ^-  @t
    ::  last element is the proper title (as text)
    ::
    =/  title  (slag (sub (lent c.title-node) 1) c.title-node)
    ?~  title  *@t
    ?~  a.g.i.title  *@t
    %-  crip
      (trim (ace:ug:re v.i.a.g.i.title))
  ::
  ++  extract-title-header
    |=  html=tape
    ^-  tape
    =+  (find "id=\"olpProductDetails\"" html)
    ?~  -
      *tape
    =/  title-div=@ud  (need -)
    =/  div=tape
      (get html title-div (lent html))
    =/  title-h1=@ud
      %-  need
      (find "<h1 " div)
    =/  title-end=@ud
      %-  need
      (find "</h1>" div)
    (get div title-h1 (add 5 title-end))
  ::
  ++  extract-price-text
    |=  price-node=manx
    ^-  @rs
    :: ~&  price-node
    =*  contents  c.price-node
    ::  first column has the price
    ::
    =/  price  (scag 1 contents)
    ?~  price  *@rs
    ?~  c.i.price  *@rs
    =*  price-arr  i.c.i.price
    ?~  a.g.price-arr  *@rs
    =/  price-tape
      (trim:string:unfurl (ace:ug:re v.i.a.g.price-arr))
    ::  slag removes currency sign. it seems to occupy 2 bytes?
    :: > `(list @)"£15.38"
    :: ~[194 163 49 53 46 51 56]
    ::  TODO: this ofc only works for amazon.co.uk and amazon.com
    ::  other countries have things like "EUR 123,45"
    ::
    `@rs`+:(scan (slag 2 price-tape) royl:so)
  ::
  ++  extract-price-row
    |=  html=tape
    ^-  tape
    =/  choices-i=@ud
      %-  need
      (find "aria-label=\"More buying choices\"" html)
    =/  choices-div=tape
      (get html choices-i (lent html))
    ::
    =/  first-offer-i=@ud
      %-  need
      (find " olpOffer\"" choices-div)
    =/  price-column=tape
      (get choices-div first-offer-i (lent choices-div))
    =/  first-offer-start=@ud
      %-  need
      (find "<div " price-column)
    =/  first-offer-end=@ud
      %-  need
      (find "</div>" price-column)
    (get price-column first-offer-start (add 6 first-offer-end))
  --
::
++  wake
  |=  [=wire error=(unit tang)]
  ^-  (quip move _this)
  =/  books=(list [id=@t b=book])  ~(tap by books.sat)
  :_  this
  ::  Loops through all the tracked books and parses the amazon page
  ::  we could potentially DDOS...
  ::
  ;:  weld
    ::  Checks again in one hour
    ::
    ^-  (list move)
    [ost.bol %wait /fetch (add now.bol ~m2)]~
    ::  Parse requests for all books
    ::
    ^-  (list move)
    %-  zing  %+  turn  (skip books |=([id=@t b=book] =(url.b "")))
      |=  p=[id=@t b=book]
      %-  request-amazon-page
        (scan url.b.p auri:de-purl:html)
  ==
::
++  http-response
  |=  [=wire response=client-response:iris]
  ^-  (quip move _this)
  ::  ignore all but %finished
  ::
  ?.  ?=(%finished -.response)  [~ this]
  =/  data=(unit mime-data:iris)  full-file.response
  ?~  data  [~ this]
  =/  p=[price=@rs title=@t id=@t]
    (parse-amazon-page (trip q.data.u.data))
  ~&  id.p
  =/  =book
    (~(got by books.sat) id.p)
  =/  up-book
    ::  If this was trigger by the timer, the title is redundant
    ::
    book(title title.p, current-price `price.p)
  =/  cp  (scow %ud (abs:si (need (toi:rs price.p))))
  =/  wp  (scow %ud (abs:si (need (toi:rs wished-price.book))))
  :_  this(books.sat (~(jab by books.sat) id.p |=(* up-book)))
  ^-  (list move)
  ::  Notify only if lower price found
  ::  FIXME: removes type information
  :: =-  (skip - |*(a=* ?=(@ a)))  ^-  (list)
  ::
  :~  %-  send:co:view
      ^-  sole-effect
      :-  %klr
      :~  [[~ ~ ~] "Current price: ["]
          ?:  (gte:rs wished-price.book price.p)
            [[```%g] "{cp}"]
          [[```%r] "{cp}"]
          :: [[~ ~ ~] "<-"]
          :: [[```%b] " {wp}"]
          [[~ ~ ~] "] for: "]
          [[```%b] "{(scag 20 (trip title.p))} ..."]
      ==
      %-  send:fe:view
        ['book' (json-book '' up-book)]~
  ==
::
++  poke-atom
  |=  a=cord
  ^-  (quip move _this)
  ~&  (parse-amazon-url (trip a))
  :_  this
  (request-amazon-page (rash a auri:de-purl:html))
::
++  poke-noun
  |=  a=*
  :_  this
  [ost.bol %wait /fetch (add now.bol ~m2)]~
::
++  json-books
  ^-  (list [@t json])
  :_  ~
  :-  'books'
  :-  %a
  %+  turn
    ~(tap by books.sat)
  json-book
::
++  json-book
  |=  [@t b=book]
  ^-  json
  %-  pairs:enjs:format
    =-  (skip - |=([@t a=json] =(a ~)))
    ^-  (list (pair @t json))
    :~  ['title' s+title.b]
        ['url' s+(crip url.b)]
        ['wishedPrice' s+(scot %rs wished-price.b)]
        :-  'currentPrice'
        ?~  current-price.b  ~
        s+(scot %rs u.current-price.b)
    ==
::
+|  %view
::  %view
::
::    Arms for displaying books on the console and frontend
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
    ::  $peer-booksfile:
    ::
    ++  peer-bookstile
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
          %o
        ::  Receive a new book from the frontend and add it
        ::
        =/  b=[@rs tape]
          %.  data  =,  dejs:format
          =-  (ot -)
          :~  =-  ['wishedPrice' (cu - so)]
              |=  c=cord
              `@rs`+:(rash c royl:^so)
              ['url' (cu trip so)]
          ==
        (add-book b)
      ::
          %b
        ::  Request to load existing nodes onto the frontend
        ::
        :_  this
        ?.  (bo:dejs data)  ~
        [(send json-books)]~
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
      %+  turn  (prey:pubsub:userlib /bookstile bol)
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
          [[```%g] "Price + Book URL "]
          [[~ ~ ~] "e.g ( "]
          [[```%b] "6.99"]
          [[```%y] " https://..."]
          [[~ ~ ~] ") | "]
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
        ?.  =(~ l)  list-books
        ::  a pair of number (integer, no decimal; e.g. 45)
        ::  and any combination of printable chars separated
        ::  by a space
        ::  TODO: replace with proper URL parser
        ::
        =/   b=(unit [(list) purl:eyre])
          %+  rust   (tufa buf.share)
          ;~((glue ace) (star ;~(pose nud dog)) auri:de-purl:html)
        ?~  b  wrong-input
        %+  add-book
          =-  `@rs`+:(scan - royl:so)
          ::  We need to make sure that we are dealing with atoms
          ::  the parser and murn deal with units (the '.') so we
          ::  need to guarantee that we won't cast arbitrary cells
          ::
          =-  (turn - |=(a=* ?:(?=(@ a) `@t`a !!)))
          ::  If the input is "23.23" the parser will give us
          ::  [i='2' t=~['3' ['.' ~] '2' '3']]
          ::  so we search for the dot and use +murn to replace
          ::  it to get <|2 3 . 2 3|>
          ::
          (murn -.u.b |*(a=* (some ?:(?=(^ a) -.a a))))
        ::
          (en-purl:html +.u.b)
      ::
          ::  %det: key press
          ::  pressed key is stored in the console state
          ::
          %det
        (edit-sole +.act)
      ==
    ::
    ++  list-books
      ^-  (quip move _this)
      =^  edit  state.consol.sat  (to-sole set+~)
      :_  this
      :_  ~
      (send mor+~[det+edit print-books])
    ::
    ++  wrong-input
      ^-  (quip move _this)
      =^  edit  state.consol.sat  (to-sole set+~)
      :_  this
      :_  ~
      (send mor+~[det+edit txt+"Incorrect format [price URL]"])
    ::
    ++  print-books
      =/  c  1
      ^-  sole-effect
      =/  books=(list [@t book])  ~(tap by books.sat)
      :-  %mor
      ^-  (list sole-effect)
      :-  txt+"....Book Watcher        price=[current/wished] ...."
      |-  ^-  (list sole-effect)
      ?~  books
        ~[txt+"..................................................."]
      =*  book  +.i.books
      =*  cp-u  current-price.book
      =/  cp
        ?~  cp-u  "?"
            (scow %ud (abs:si (need (toi:rs u.cp-u))))
            :: (scow %rs u.cp-u)
      =/  wp  ::(scow %rs wished-price.book)
        (scow %ud (abs:si (need (toi:rs wished-price.book))))
      =/  short=tape  (scag 20 (trip title.book))
      :-  :-  %klr
      ^-  styx
      :~  [[~ ~ ~] "{<c>}. {short} ... -> ["]
          ?~  cp-u
            [[~ ~ ~] "{cp} "]
          ?:  (gte:rs wished-price.book u.cp-u)
            [[```%g] "{cp} "]
          [[```%r] "{cp} "]
          [[~ ~ ~] "/"]
          [[```%b] " {wp}"]
          [[~ ~ ~] "]"]
      ==
      $(books t.books, c +(c))
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

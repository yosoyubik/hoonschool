|%
::  String related
::
++  string
  |%
  ::
  ::  Find the starting index of the nth occurence of nedl in the string.
  ++  find-nth
    |=  [str=tape nedl=tape n=@ud]
    ^-  (unit @ud)
    ::TODO  Be less lazy, maybe.
    =+  res=(fand nedl str)
    ?:  (gth n (lent res))  ~
    [~ (snag (sub n 1) res)]
  ::
  ::  Get b characters starting from index a.
  ::  (swag [a b] str)
  ::
  ::  Characters from index a up to but excluding index b.
  ::
  ++  get
    |=  [str=tape a=@ud b=@ud]
    ^-  tape
    ?:  (gth a b)  ~
    (swag [a (sub b a)] str)
  ::
  ::  Delete b characters from the string, starting at index a.
  ::  (oust [a b] str)
  ::
  ::  Delete characters from index a up to but excluding index b.
  ::
  ++  delete
    |=  [str=tape a=@ud b=@ud]
    ^-  tape
    ?:  (gth a b)  ~
    (oust [a=a b=(sub b a)] str)  ::TODO  Remove faces when bug is fixed.
  ::  Trim whitespace off string left-side.
  ++  trim-left
    |=  str/tape
    ^-  tape
    (scan str ;~(pfix spac:de-json:html (star next)))
  ::
  ::  Trim whitespace off string right-side.
  ++  trim-right
    |=  str/tape
    ^-  tape
    ::TODO  Be less lazy, maybe.
    %-  flop
    (trim-left (flop str))
  ::
  ::  Trim whitespace off string ends.
  ++  trim
    |=  str/tape
    ^-  tape
    (trim-left (trim-right str))
  --
++  titl
  :~  "twitter:title"
      "og:title"
  ==
++  desc
  :~
    "og:description"
    "twitter:description"
  ==
++  imag
  :~
    "og:image"
    "twitter:image"
  ==
++  type
  :~
    "twitter:card"
  ==
:: do we need size?
++  play
  :~
    "og:video:url"
    "twitter:player"
  ==
++  pwid
  :~
    "og:video:width"
    "twitter:player:width"
  ==
++  phei
  :~
    "og:video:height"
    "twitter:player:height"
  ==
++  url
  :~
    "og:url"
    "twitter:url"
  ==
++  meta
  $:  titl=(unit @t)
      desc=(unit @t)
      imag=(unit @t)
      play=(unit @t)
      pwid=(unit @t)
      phei=(unit @t)
      url=(unit @t)
      seri=(unit @t)
  ==
::  find arbitrary tags
++  get-prop
  |=  [nodelist=(list marx) props=(list tape)]
  =/  out=(unit @t)  ~
  ^-  (unit @t)
  |-
  ?~  nodelist  out
  ::
  %=  $
    out   =/  x  %+  grab-prop
              -.nodelist
            props
        ?~  x  out  (bind x crip)
    nodelist  +.nodelist
  ==
++  grab-prop
  |=  [node=marx props=(list tape)]
  =/  q=?  |
  =/  out=tape  ~
  ^-  (unit tape)
  |-
  ?~  a.node  ?:(q `out ~)
  %=  $
    a.node  +.a.node
    q   ?~  (find ~[v.i:-.a.node] props)
          q
        &
    out   ?:  ?=([%content *] -.a.node)
          ->.a.node
        out
  ==
++  parse-tag
  |=  a=@
  ^-  (unit marx)
  =/  b  (rush a head:de-xml:html)
  :: needs to be a way to invert this?
  ?~  b
    =/  c  (rush a empt:de-xml:html)
    ?~  c
      c
    `-.u.c
  b
++  find-all-tags
  |=  [st=tape tsta=tape tsto=tape]
  ^-  (list marx)
  =/  ind  (fand tsta st)
  =/  stout=(list marx)  ~
  |-
  ?~  ind  stout
  %=  $
    ind  +.ind
    stout  =/  x  %-  parse-tag
                  %-  crip
                  %^    find-tags
                      %^    get:string
                          st
                        -.ind
                      ?:  (gth (lent ind) 1)
                        +<.ind
                      (lent st)
                    tsta
                  tsto
           ?~  x  stout
           %+  welp
             stout
           :_  ~
           u.x
  ==
++  find-tags
  |=  [st=tape tsta=tape tsto=tape]
  :: return tag and contents
  ^-  tape
  =/  sta
  (find tsta st)
  ?~  sta  ~
  =/  sto
  (find tsto (get:string st u.sta (lent st)))
  ?~  sto  ~
  (get:string st u.sta (add (add u.sta u.sto) (lent tsto)))
:: take in html, return meta object
++  is-image
  |=  a=purl:eyre
  ^-  ?
  =*  ext  p.q.a
  ?~  ext  |
    ?:  ?|  =('jpg' (fall ext ''))
            =('jpeg' (fall ext ''))
            =('png' (fall ext ''))
            =('gif' (fall ext ''))
            =('tiff' (fall ext ''))
            =('JPG' (fall ext ''))
            =('JPEG' (fall ext ''))
            =('PNG' (fall ext ''))
        ==
        &
    |
::
::
::
++  metadata
  |=  [ser=@t htm=octs]
  ^-  (unit meta)
  =/  tmp  (find-all-tags (trip q.htm) "<meta" ">")
  ::  identify empties here
  =/  t  (get-prop tmp titl)
  =/  d  (get-prop tmp desc)
  =/  i  (get-prop tmp imag)
  =/  p  (get-prop tmp play)
  :: test
  ?:  ?&  ?=($~ (fall t ~))
          ?=($~ (fall d ~))
          ?=($~ (fall i ~))
          ?=($~ (fall p ~))
      ==
      ~
  %-  some
  :*
      t
      d
      i
      p
      (get-prop tmp pwid)
      (get-prop tmp phei)
      (get-prop tmp url)
      `ser
  ==
:: used for oembed
++  find-html
  |=  st=tape
  ^-  (unit (pair @u @u))
  ::`[0 0]
  =/  sta  (find "id=\"olpProductDetails\"" st)
  ?~  sta  ~&  "nula"  ~
  =/  get-string  (get:string st u.sta (lent st))
  ~&  get-string
  =/  sto
    (find-nth:string get-string "," 1)
  ?~  sto  ~&  "nulidad"  ~
  `[u.sta (add u.sta u.sto)]
++  trim-html
  |=  st=tape
  ^-  (unit tape)
  =/  sta  (find ": " st)
  ?~  sta  ~&  "nulisima"  ~
  `(get:string st (add u.sta 2) (sub (lent st) 1))
++  extract-html
  |=  st=tape
  ^-  (unit (pair tape tape))
  =/  in  (find-html st)
  ?~  in  ~&  "nulo..."  ~
  =/  get-string  (get:string st p.u.in (add q.u.in 1))
  ~&  get-string
  =/  ht  (trim-html get-string)
  ?~  ht  ~
  `[(delete:string st p.u.in (add q.u.in 1)) u.ht]
--

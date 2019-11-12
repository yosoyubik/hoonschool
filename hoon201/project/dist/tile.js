const _jsxFileName = "/Users/jose/Dropbox/urbit/hoonschool/hoon201/project/tile/tile.js";import React, { Component } from 'react';
import classnames from 'classnames';
import _ from 'lodash';

class EnterBook extends React.Component {

  keyPress(e) {
    if (e.keyCode === 13) {
      e.preventDefault();
      this.props.send(e.target.value);
    }
  }

  render() {
    return(
      React.createElement('form', { className: "flex absolute" , style: {left: 30, bottom: 0}, __self: this, __source: {fileName: _jsxFileName, lineNumber: 16}}
        , React.createElement('input', { id: "book",
          className: "white pa1 bg-transparent outline-0 bn bb-ns b--white"      ,
          style: {width: "86%"},
          type: "text",
          onKeyDown: this.keyPress.bind(this), __self: this, __source: {fileName: _jsxFileName, lineNumber: 17}}
        )
      )
    )
  }
}

export default class booksTile extends Component {

  constructor(props) {
    super(props);

    let ship = window.ship;
    let api = window.api;
    let store = window.store;

    this.state = {
      books: [],
    };
  }

  handleClick(book) {
    let wishedPrice = book.split(' ')[0]
    let url = book.split(' ')[1]
    let jsonBook = {'wishedPrice': wishedPrice, 'url': url};
    console.log(jsonBook);
    api.action('books', 'json', {'data': jsonBook});
  }

  componentDidMount() {
    console.log("asking for data to urbit");
    api.action('books', 'json', {'data': true});
  }

  componentDidUpdate(prevProps, prevState, snapshot) {
    const data = !!this.props.data ? this.props.data : {};
    let books = this.state.books.slice();
    if (data === null) {
      // We reset state
      this.setState({
        books: []
      });
    }
    // Typical usage (don't forget to compare props):
    else if (snapshot !== null) {
      if (data !== prevProps.data) {
        // We receive a diff from our app
        if ('books' in data) {
          this.setState({
            books: data.books
          });
        }
        else if ('book' in data) {

          // Is the data already here?
          let found = books.findIndex(function(el){
            console.log("eq", el, data.book);
            return _.isEqual(el, data.book);
          });
          console.log(found);
          if (found === -1){
            console.log("new book added", data.book);
            books.push(data.book);
          }else{
            console.log("book updated", data.book);
            books[found] = data.book;
          }
          this.setState({
            books: books
          });
        }
      }
    }
  }

  render() {
    let data = !!this.props.data ? this.props.data : {};

    const books = this.state.books;
    const booksElements = books.reverse().map((book, i) => {
      const currentPrice = parseFloat(book.currentPrice.substring(1));
      const wishedPrice = parseFloat(book.wishedPrice.substring(1));
      return (
        React.createElement('li', { key: i, className: "ph3 pv2 bb white"   ,
            style: { width: 534 }, __self: this, __source: {fileName: _jsxFileName, lineNumber: 104}}
          , React.createElement('p', { className: "f6 fw4 ml0"  , __self: this, __source: {fileName: _jsxFileName, lineNumber: 106}}, book.title)
          , React.createElement('p', {__self: this, __source: {fileName: _jsxFileName, lineNumber: 107}}, "["
            , React.createElement('span', { className: 
              classnames("f7", "fw4", "ml0", "i",
              {"green": currentPrice<=wishedPrice, "red": currentPrice>wishedPrice})
            , __self: this, __source: {fileName: _jsxFileName, lineNumber: 108}}
              , currentPrice
            ), "/"

            , React.createElement('span', { className: "blue i f7 fw4 ml0"    , __self: this, __source: {fileName: _jsxFileName, lineNumber: 115}}, wishedPrice), "]"

          )
        )
      );
    });
    return (
      React.createElement('div', { className: "pa2 relative" ,
           style: { background: '#1a1a1a',
                    width: 234,
                    height: 234 }, __self: this, __source: {fileName: _jsxFileName, lineNumber: 122}}
        , React.createElement('p', { className: "gray label-regular b absolute"   ,
           style: { left: 8, top: 4 }, __self: this, __source: {fileName: _jsxFileName, lineNumber: 126}}, "Price Tracker [current / wished]"

        )

        , React.createElement('ul', { className: " w-100 list pl0 ml0 center mw5 ba b--light-silver br3 .overflow-y-auto-m"          ,
            style: {
                height: 150,
                overflow: 'auto',
                marginTop: 25
            }, __self: this, __source: {fileName: _jsxFileName, lineNumber: 131}}
            , booksElements
        )
        , React.createElement('div', { className: "mt3", __self: this, __source: {fileName: _jsxFileName, lineNumber: 139}}
          , React.createElement(EnterBook, { send: this.handleClick.bind(this), __self: this, __source: {fileName: _jsxFileName, lineNumber: 140}} )
        )
      )
    );
  }

}

window.booksTile = booksTile;

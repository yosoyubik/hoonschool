import React, { Component } from 'react';
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
      <form className="flex absolute" style={{left: 30, bottom: 0}}>
        <input id="book"
          className="white pa1 bg-transparent outline-0 bn bb-ns b--white"
          style={{width: "86%"}}
          type="text"
          onKeyDown={this.keyPress.bind(this)}>
        </input>
      </form>
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
        <li key={i} className="ph3 pv2 bb white"
            style={{ width: 534 }}>
          <p className="f6 fw4 ml0">{book.title}</p>
          <p>[
            <span className={
              classnames("f7", "fw4", "ml0", "i",
              {"green": currentPrice<=wishedPrice, "red": currentPrice>wishedPrice})
            }>
              {currentPrice}
            </span>
            /
            <span className="blue i f7 fw4 ml0">{wishedPrice}</span>
            ]
          </p>
        </li>
      );
    });
    return (
      <div className="pa2 relative"
           style={{ background: '#1a1a1a',
                    width: 234,
                    height: 234 }}>
        <p className="gray label-regular b absolute"
           style={{ left: 8, top: 4 }}>
           Price Tracker [current / wished]
        </p>

        <ul className=" w-100 list pl0 ml0 center mw5 ba b--light-silver br3 .overflow-y-auto-m"
            style={{
                height: 150,
                overflow: 'auto',
                marginTop: 25
            }}>
            {booksElements}
        </ul>
        <div className="mt3">
          <EnterBook send={this.handleClick.bind(this)} />
        </div>
      </div>
    );
  }

}

window.booksTile = booksTile;

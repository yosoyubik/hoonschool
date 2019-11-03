import React, { Component } from 'react';
import classnames from 'classnames';
import _ from 'lodash';

class EnterNote extends React.Component {

  keyPress(e) {
    if (e.keyCode === 13) {
      e.preventDefault();
      this.props.send(e.target.value);
    }
  }

  render() {
    return(
      <form className="flex absolute" style={{left: 30, bottom: 0}}>
        <input id="note"
          className="white pa1 bg-transparent outline-0 bn bb-ns b--white"
          style={{width: "86%"}}
          type="text"
          onKeyDown={this.keyPress.bind(this)}>
        </input>
      </form>
    )
  }
}

export default class notesTile extends Component {

  constructor(props) {
    super(props);

    let ship = window.ship;
    let api = window.api;
    let store = window.store;

    this.state = {
      notes: [],
    };
  }

  handleClick(note) {
    console.log(note);
    let notes = this.state.notes.reverse().slice();
    notes.push(note);
    api.action('notes', 'json', {'data': note});
    this.setState({
      notes: notes
    });
  }

  componentDidMount() {
    console.log("asking for data to urbit");
    api.action('notes', 'json', {'data': true});
  }

  componentDidUpdate(prevProps, prevState, snapshot) {
    const data = !!this.props.data ? this.props.data : {};
    let notes = this.state.notes;
    if (data === null) {
      // We reset state
      this.setState({
        notes: []
      });
    }
    // Typical usage (don't forget to compare props):
    else if (snapshot !== null) {
      if (data !== prevProps.data) {
        // We receive a diff from our app
        if ('notes' in data) {
          this.setState({
            notes: data.notes
          });
        }
        if ('note' in data) {
          notes.push(data.note);
          this.setState({
            notes: notes
          });
        }
      }
    }
  }

  render() {
    let data = !!this.props.data ? this.props.data : {};

    const notes = this.state.notes;
    const notesElements = notes.reverse().map((note, i) => {
      return (
        <li key={i} className="ph3 pv2 bb white">
          <p>{note}</p>
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
           Sticky Notes
        </p>
        <ul className=" w-100 list pl0 ml0 center mw5 ba b--light-silver br3 .overflow-y-auto-m"
            style={{
                height: 150,
                overflow: 'auto',
                marginTop: 25
            }}>
            {notesElements}
        </ul>
        <div className="mt3">
          <EnterNote send={this.handleClick.bind(this)} />
        </div>
      </div>
    );
  }

}

window.notesTile = notesTile;

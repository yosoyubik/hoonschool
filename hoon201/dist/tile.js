const _jsxFileName = "/Users/jose/Dropbox/urbit/hoonschool/hoon201/week7-tile/tile.js";import React, { Component } from 'react';
import classnames from 'classnames';
import { sigil, reactRenderer } from 'urbit-sigil-js'

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

  sendNote(note) {
    api.action('week7', 'json', {'data': note});
  }

  handleClick(note) {
    const notes = this.state.notes.slice();
    notes.push(note);
    sendNote(note);
    this.setState({
      notes: notes
    });
  }

  renderWrapper(child) {
    return (
      React.createElement('div', { className: "pa2 relative" , style: {
        width: 234,
        height: 234,
        background: '#1a1a1a'
      }, __self: this, __source: {fileName: _jsxFileName, lineNumber: 34}}
        , child
      )
    );
  }

  componentDidUpdate(prevProps, prevState, snapshot) {
    const data = !!this.props.data ? this.props.data : {};
    if (data === null) {
      // We reset state
      this.setState({
        notes: []
      });
    }
    // Typical usage (don't forget to compare props):
    else if (snapshot !== null) {
      let diff = !!data.data ? data.data : "";
      if (data !== prevProps.data) {
        // We receive a diff from our app
        if ('notes' in diff) {
          notes.push(diff.notes);
          this.setState({
            notes: diff.notes
          });
        }
        if ('note' in diff) {
          notes.push(diff.note);
          this.setState({
            notes: notes
          });
        }
      }
    }
  }

  render() {
    let data = !!this.props.data ? this.props.data : {};
    let bottomElement;

    const notes = this.state.notes;
    const notesElements = notes.map((i, note) => {
      return (
        React.createElement('li', {__self: this, __source: {fileName: _jsxFileName, lineNumber: 80}}
          , React.createElement('p', {__self: this, __source: {fileName: _jsxFileName, lineNumber: 81}}, i, ": " , note)
        )
      );
    });
    // <div class="mt3">
    //   <label class="db fw4 lh-copy f6" for="email-address">Enter note: </label>
    //   <input class="pa2 input-reset ba bg-transparent w-100 measure" id="note-input" />
    // </div>
    // <div> Notes: </div>
    // <ol> {notesElements} </ol>
    return (
      React.createElement('div', { className: "w-100 h-100 relative"  , style: { background: '#1a1a1a' }, __self: this, __source: {fileName: _jsxFileName, lineNumber: 92}}
        , React.createElement('p', { className: "gray label-regular b absolute"   , style: { left: 8, top: 4 }, __self: this, __source: {fileName: _jsxFileName, lineNumber: 93}}, "Sticky Notes" )
        , React.createElement('div', { class: "mt3", __self: this, __source: {fileName: _jsxFileName, lineNumber: 94}}
          , React.createElement('label', { className: "db fw4 lh-copy f6"   , __self: this, __source: {fileName: _jsxFileName, lineNumber: 95}}, "Enter note: "  )
          , React.createElement('input', { className: "pa2 input-reset ba bg-transparent w-100 measure"     , id: "note-input", __self: this, __source: {fileName: _jsxFileName, lineNumber: 96}})
        )
        , React.createElement('div', {__self: this, __source: {fileName: _jsxFileName, lineNumber: 98}}, " Notes: "  )
        , React.createElement('ol', {__self: this, __source: {fileName: _jsxFileName, lineNumber: 99}}, " " , notesElements, " " )
      )
    );
  }
}

window.notesTile = notesTile;

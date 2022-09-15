import * as React from 'react';
import * as ReactDOM from 'react-dom';
import Router from './router';
import './index.css';

document.addEventListener("DOMContentLoaded", () => {
  const rootEl = document.getElementById('uploader');

  ReactDOM.render(
    <Router />,
    rootEl
  );
})


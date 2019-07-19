import * as React from 'react';
import * as ReactDOM from 'react-dom';
import 'semantic-ui-css/semantic.min.css';
import 'whatwg-fetch'
import { BrowserRouter as Router, Route } from 'react-router-dom';
import { App } from './app';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Router basename="registrar/admin">
      <Route path="/" component={App}/>
    </Router>,
    document.getElementById('rms-admin')
  );
})

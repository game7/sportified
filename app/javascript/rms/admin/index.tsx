import * as React from 'react';
import * as ReactDOM from 'react-dom';
import 'semantic-ui-css/semantic.min.css';
import 'whatwg-fetch'
import { Container } from 'semantic-ui-react';

import Router from './router';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Container>
      <div></div>
      <h1>RMS Admin</h1>
      <Router/>
    </Container>,
    document.getElementById('rms-admin')
  );
})

import * as React from 'react';
import * as ReactDOM from 'react-dom';
import 'semantic-ui-css/semantic.min.css';
import 'whatwg-fetch'
import { BrowserRouter as Router } from 'react-router-dom';
import { Container } from 'semantic-ui-react';
import Menu from './menu';

import Routes from './routes';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Router basename="registrar/admin">
      <div>
        <Menu/>
        <Container>
          <Routes/>
        </Container>
      </div>
    </Router>,
    document.getElementById('rms-admin')
  );
})

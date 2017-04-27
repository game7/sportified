import * as React from 'react';
import * as ReactDOM from 'react-dom';
import 'semantic-ui-css/semantic.min.css';
import Main from './main'

const App = () => (
  <Main/>
)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <App/>,
    document.getElementById('main')
  );
})

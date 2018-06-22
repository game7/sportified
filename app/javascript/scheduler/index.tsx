import React from 'react';
import ReactDOM from 'react-dom';
import {
  Route,
  Link,
  BrowserRouter as Router
} from 'react-router-dom';
import Calendar from './calendar';

const Index = () => (
  <Router basename="/admin/events/proto">
    <div>
      <Route path="/" component={Calendar}/>
    </div>
  </Router>
);

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Index/>,
    document.getElementById('page-header').appendChild(document.createElement('div'))
  );
})


import * as React from 'react';
import * as ReactDOM from 'react-dom';

const Hello = props => (
  <div className="alert alert-success">Hello Chris</div>
)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Hello/>,
    document.getElementById('page-header').appendChild(document.createElement('div'))
  );
})

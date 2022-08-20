import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Edit } from './edit';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Edit />,
    document.getElementById('main').appendChild(document.createElement('div'))
  );
})

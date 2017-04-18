import * as React from 'react';
import * as ReactDOM from 'react-dom';
import 'whatwg-fetch';
import { Edit } from './edit';


document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Edit/>,
    document.getElementById('main').appendChild(document.createElement('div'))
  );
})

import React, { useState } from 'react'
import 'semantic-ui-css/semantic.css'
import { BrowserRouter as Router, Route } from 'react-router-dom';
import Routes from './routes';
import "./index.css";

export const Console: React.FC<{}> = (props) => {
  console.log(props)
  return (
    <Router basename="admin/console">
      <Route path="/" component={Routes}/>
    </Router>
  )
}

export default Console

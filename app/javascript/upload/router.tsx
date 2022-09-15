import {
  Route,
  Link,
  BrowserRouter as Router
} from 'react-router-dom';

import App from './app';
import Games from './games';
import Practices from './practices';
import Events from './events';
import Players from './players';
import { useEffect, useState } from 'react';

const Home = () => (
  <ul>
    <li><Link to="/events">Events</Link></li>
    <li><Link to="/games">Games</Link></li>
    <li><Link to="/practices">Practices</Link></li>
    <li><Link to="/players">Players</Link></li>
  </ul>
);

export default function RouterComponent() {
  return (
    <Router basename="/admin/uploads">
      <div>
        <App>
          <Route path="/" exact component={Home} />
          <Route path="/games" component={Games} />
          <Route path="/practices" component={Practices} />
          <Route path="/events" component={Events} />
          <Route path="/players" component={Players} />
        </App>
      </div>
    </Router>
  )
}

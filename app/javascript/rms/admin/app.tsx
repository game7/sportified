import * as React from 'react';
import {
  BrowserRouter as Router,
  Route,
  Link,
  RouteComponentProps
} from 'react-router-dom';
import { Container } from 'semantic-ui-react';

import Menu from './menu';
import Items from './pages/items';
import Registrations from './pages/registrations';

const Home: React.SFC<{}> = () => (
  <div>
    <strong>Home</strong>
  </div>
);

const About: React.SFC<{}> = () => (
  <div>
    <strong>About</strong>
  </div>
);

export const App = (props: RouteComponentProps<{}>) => {
  return (
    <div>
      <Menu location={props.location.pathname}/>
      <Container>
        <Route exact path="/" component={Home}/>
        <Route path="/items" component={Items}/>
        <Route path="/registrations" component={Registrations}/>
        <Route path="/about" component={About}/>
      </Container>
    </div>
  )
}

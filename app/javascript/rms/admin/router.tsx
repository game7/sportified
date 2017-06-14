import * as React from 'react';
import {
  BrowserRouter as Router,
  Route,
  Link,
  RouteComponentProps
} from 'react-router-dom';
import {
  Grid,
  Menu,
  Container
} from 'semantic-ui-react';

import Items from './containers/items';

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

const HomeMenu = () => (
  <Menu  fluid vertical >
    <Menu.Item>
      <Menu.Header>Registrar</Menu.Header>
      <Menu.Menu>
        <Menu.Item as={Link} to='/'>Home</Menu.Item>
        <Menu.Item as={Link} to='/items'>Items</Menu.Item>
        <Menu.Item as={Link} to='/about'>About</Menu.Item>
      </Menu.Menu>
    </Menu.Item>
  </Menu>
)


class ItemMenu extends React.Component<RouteComponentProps<{ id: string }>,{}> {
  render() {
    const id = this.props.match.params.id;
    return (
      <Menu  fluid vertical >
        <Menu.Item>
          <Menu.Header>Registrar</Menu.Header>
          <Menu.Menu>
            <Menu.Item as={Link} to='/'>Home</Menu.Item>
          </Menu.Menu>
        </Menu.Item>
        <Menu.Item>
          <Menu.Header>Item Menu</Menu.Header>
          <Menu.Menu>
            <Menu.Item as={Link} to={`/items/${id}`}>Dashboard</Menu.Item>
            <Menu.Item as={Link} to={`/items/${id}/registrations`}>Registrations</Menu.Item>
          </Menu.Menu>
        </Menu.Item>
      </Menu>
    )
  }
}


export default () => (
  <Router basename="registrar/admin">
    <Grid>
      <Grid.Column width={3} >
        <Route exact path="/" component={HomeMenu}/>
        <Route exact path="/items/" component={HomeMenu}/>
        <Route path="/items/:id" component={ItemMenu}/>
      </Grid.Column>

      <Grid.Column stretched width={13} style={{}}>
          <Route exact path="/" component={Home}/>
          <Route path="/items" component={Items}/>
          <Route path="/about" component={About}/>
      </Grid.Column>
    </Grid>
  </Router>
);

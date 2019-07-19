import * as React from 'react';
import { RouteComponentProps, Route, Link } from 'react-router-dom';
import { Menu } from 'semantic-ui-react';
import { Item } from '../../data';

import Dashboard from './dashboard';
import Registrations from './registrations';

interface Props extends RouteComponentProps<{id: number}> {

}

interface State {
  item: Item
}

export default class Index extends React.Component<Props,State> {

  componentWillMount() {
    this.setState({});
    fetch(`/registrar/api/items/${this.props.match.params.id}`)
      .then(response => response.json())
      .then<Item>(payload => payload.item)
      .then(item => { this.setState({ item }) });
  }

  render() {
    const { item } = this.state;
    if (!item) return (<div/>);
    console.log(this.props.match)
    return (
      <div>
        <h2>{item.title}</h2>
        <Route
          exact
          path={`${this.props.match.url}/`}
          render={(props) => (
            <div>
              <Menu>
                <Menu.Item
                  as={Link}
                  to={`/items/${item.id}`}
                  active={true}
                  content="Dashboard"
                />
                <Menu.Item
                  as={Link}
                  to={`/items/${item.id}/registrations`}
                  active={props.match.url == `/items/${item.id}/registrations`}
                  content="Registrations"
                />
              </Menu>
              <Dashboard {...props} item={item} />
            </div>
          )}/>
        <Route
          path={`${this.props.match.url}/registrations`}
          render={(props) => (
            <div>
            <Menu>
              <Menu.Item
                as={Link}
                to={`/items/${item.id}`}
                content="Dashboard"
              />
              <Menu.Item
                as={Link}
                to={`/items/${item.id}/registrations`}
                active={true}
                content="Registrations"
              />
            </Menu>
              <Registrations {...props} item={item} />
            </div>
          )}/>
      </div>
    )
  }

}

import * as React from 'react';
import { RouteComponentProps, Route } from 'react-router-dom';
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
    return (
      <div>
        <Route
          exact
          path={`${this.props.match.url}/`}
          render={(props) => <Dashboard {...props} item={item} />}/>
        <Route
          path={`${this.props.match.url}/registrations`}
          render={(props) => <Registrations {...props} item={item} />}/>
      </div>
    )
  }

}

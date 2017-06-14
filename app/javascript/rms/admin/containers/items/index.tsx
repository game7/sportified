import * as React from 'react';
import { RouteComponentProps, Route } from 'react-router-dom';

import ItemsList from './list';
import ItemIndex from '../item';

interface Props extends RouteComponentProps<{}> {

}

interface State {

}

export default class Index extends React.Component<Props,State> {

  render() {
    return (
      <div>
        <Route exact path={`${this.props.match.url}/`} component={ItemsList}/>
        <Route path={`${this.props.match.url}/:id`} component={ItemIndex}/>
      </div>
    )
  }

}

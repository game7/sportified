import * as React from 'react';
import { RouteComponentProps, Route, Link } from 'react-router-dom';
import { Menu } from 'semantic-ui-react';

import RegistrationsList from './list';
import RegistrationsShow from './show';

interface Props extends RouteComponentProps<{}> {

}

interface State {

}

export default class Index extends React.Component<Props,State> {

  render() {
    return (
      <div>
        <Route exact path={`${this.props.match.url}/`} component={RegistrationsList}/>
        <Route path={`${this.props.match.url}/:id`} component={RegistrationsShow}/>
      </div>
    )
  }

}

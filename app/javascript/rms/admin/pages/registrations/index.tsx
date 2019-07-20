import React, { FC } from 'react';
import { Route, RouteComponentProps } from 'react-router-dom';

import RegistrationsList from './list';
import RegistrationsShow from './show';

interface Props extends RouteComponentProps<{}> {
  
}

const Index: FC<Props> = ({ match }) => {

  return (
    <div>
      <Route exact path={`${match.url}/`} component={RegistrationsList}/>
      <Route path={`${match.url}/:id`} component={RegistrationsShow}/>
    </div>
  )

}

export default Index;

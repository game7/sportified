import React, { FC } from 'react';
import { RouteComponentProps, Route } from 'react-router-dom';

import ItemsList from './list';
import ItemIndex from '../item';

interface Props extends RouteComponentProps<{}> {

}

const Index : FC<Props> = ({ match }) => {

  return (
    <div>
      <Route exact path={`${match.url}/`} component={ItemsList}/>
      <Route path={`${match.url}/:id`} component={ItemIndex}/>
    </div>
  )

}

export default Index;
import React, { FC } from 'react';
import { Route, RouteComponentProps } from 'react-router-dom';
import Layout from '../../components/layout';
import List from './list'

export const Router: FC<RouteComponentProps<{}>> = (props) => {
  return (
    <React.Fragment>
      <Route path={`${props.match.path}/`} exact component={List}/>
    </React.Fragment>
  )
}

export default Router;

import React, { FC } from 'react';
import { Route, RouteComponentProps } from 'react-router-dom';
import Layout from '../../components/layout';
import Calendar from "./calendar"

const Home: FC<{}> = () => {
  return (
    <Layout title="Calendar"></Layout>
  )
}

export const Router: FC<RouteComponentProps<{}>> = (props) => {
  return (
    <React.Fragment>
      <Route path={`${props.match.path}/`} exact component={Calendar}/>
    </React.Fragment>
  )
}

export default Router;

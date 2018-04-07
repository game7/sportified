import * as React from 'react';
import { Route } from 'react-router-dom';
import Show from './show';

const Layout: React.SFC<{}> = (props) => (
  <div>{props.children}</div>
)

const routes = (
  <Route path="leagues">
    <Layout>
      <Route exact path="/" component={Show}/>
      <Route path=":programId(/seasons/:seasonId)" component={Show}/>
    </Layout>
  </Route>
);

export default routes;

import * as React from 'react';
import { Route, RouteComponentProps } from 'react-router-dom';
import List from './list';
import Import from './import';

const Layout: React.SFC<{}> = (props) => (
  <div>
    {props.children}
  </div>
)

const Players: React.SFC<RouteComponentProps<{}>> = (props) => (
  <Layout>
    <Route path={`${props.match.path}/`} exact component={List}/>
    <Route path={`${props.match.path}/import`} component={Import}/>
  </Layout>
)

export default Players;

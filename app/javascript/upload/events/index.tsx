import * as React from 'react';
import { Route, RouteComponentProps } from 'react-router-dom';

import Context from './context';
import File from './file';
import Data from './data';
import Columns from './columns';
import Mapping from './mapping';
import Review from './review';

const Layout: React.SFC<{}> = (props) => (
  <div>
    <h4>Events</h4>
    {props.children}
  </div>
)

const Import: React.SFC<RouteComponentProps<{}>> = (props) => (
  <Layout>
    <Route path={`${props.match.path}/`} exact component={File}/>
    <Route path={`${props.match.path}/data`} component={Data}/>
    <Route path={`${props.match.path}/columns`} component={Columns}/>
    <Route path={`${props.match.path}/mapping`} component={Mapping}/>
    <Route path={`${props.match.path}/review`} component={Review}/>
  </Layout>
);

export default Import;

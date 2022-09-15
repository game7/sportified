import * as React from 'react';
import { Route, RouteComponentProps } from 'react-router';

import Context from './context';
import File from './file';
import Data from './data';
import Columns from './columns';
import Mapping from './mapping';
import Review from './review';

const Layout: React.SFC<{}> = ({ children }) => (
  <div>{children}</div>
);

const Import: React.FC<RouteComponentProps<{}>> = ({ match }) => (
  <Layout>
    <Route exact path={`${match.path}/`} component={Context} />
    <Route path={`${match.path}/file`} component={File} />
    <Route path={`${match.path}/data`} component={Data} />
    <Route path={`${match.path}/columns`} component={Columns} />
    <Route path={`${match.path}/mapping`} component={Mapping} />
    <Route path={`${match.path}/review`} component={Review} />
  </Layout>
);

export default Import;

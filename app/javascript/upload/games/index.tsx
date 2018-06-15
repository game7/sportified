import * as React from 'react';
import { Route, Switch, RouteComponentProps } from 'react-router-dom';
import List from './list';
import Import from './import';

class Layout extends React.Component<any, any> {
  render() {
    return (
      <div>
        {this.props.children}
      </div>
    );
  }
}

const Index: React.SFC<RouteComponentProps<{}>> = (props) => (
  <Layout>
    <Switch>
      <Route path={`${props.match.path}/`} exact component={List}/>
      <Route path={`${props.match.path}/import`} component={Import}/>
    </Switch>
  </Layout>
)

export default Index;

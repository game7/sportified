import React, { FC } from 'react';
import { Route, RouteComponentProps, Switch } from 'react-router-dom';
import List from "./list"
import Edit from "./edit";
import New from "./new";
import Show from "./show";

export const Locations: FC<RouteComponentProps<{}>> = (props) => {
  return (
    <Switch>
      <Route path={`${props.match.path}/`} exact component={List}/>
      <Route path={`${props.match.path}/new`} exact component={New}/>
      <Route path={`${props.match.path}/:id/edit`} component={Edit}/>
      <Route path={`${props.match.path}/:id/seasons/:seasonId`} component={Show}/>
      <Route path={`${props.match.path}/:id`} component={Show}/>
    </Switch>
  )
}

export default Locations;

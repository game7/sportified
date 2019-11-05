import React, { FC } from 'react';
import { Route, RouteComponentProps, Switch } from 'react-router-dom';
import Edit from "./edit";
// import New from "./new";

export const Locations: FC<RouteComponentProps<{}>> = (props) => {
  return (
    <Switch>
      {/* <Route path={`${props.match.path}/new`} exact component={New}/> */}
      <Route path={`${props.match.path}/:id/edit`} component={Edit}/>
    </Switch>
  )
}

export default Locations;

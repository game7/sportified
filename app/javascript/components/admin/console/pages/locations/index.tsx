import React, { FC } from 'react';
import { Route, RouteComponentProps } from 'react-router-dom';
import List from "./list"
import Edit from "./edit";
import New from "./new";

export const Locations: FC<RouteComponentProps<{}>> = (props) => {
  return (
    <React.Fragment>
      <Route path={`${props.match.path}/`} exact component={List}/>
      <Route path={`${props.match.path}/new`} exact component={New}/>
      <Route path={`${props.match.path}/:id/edit`} component={Edit}/>
    </React.Fragment>
  )
}

export default Locations;

import React, { FC } from 'react';
import { Route, RouteComponentProps } from 'react-router-dom';
import List from "./list"
import Edit from "./edit";
import New from "./new";
import Show from "./show";

export const Teams: FC<RouteComponentProps<{}>> = (props) => {
  return (
    <React.Fragment>
      <Route path={`${props.match.path}/`} exact component={List}/>
      <Route path={`${props.match.path}/new`} exact component={New}/>
      <Route path={`${props.match.path}/:id/edit`} exact component={Edit}/>
      <Route path={`${props.match.path}/:id`} exact component={Show}/>
    </React.Fragment>
  )
}

export default Teams;

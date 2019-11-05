import React, { FC } from 'react';
import { Route, RouteComponentProps } from 'react-router-dom';
import List from "./list";
import Edit from "./edit";

export const Pages: FC<RouteComponentProps<{}>> = (props) => {
  return (
    <React.Fragment>
      <Route path={`${props.match.path}/`} exact component={List}/>
      <Route path={`${props.match.path}/:id`} component={Edit}/>
    </React.Fragment>
  )
}

export default Pages;

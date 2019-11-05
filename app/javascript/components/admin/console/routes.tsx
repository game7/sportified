import React, { FC, useEffect } from 'react'
import { Route, withRouter, RouteComponentProps } from 'react-router-dom';
import Calendar from './pages/calendar';
import Dashboard from './pages/dashboard';
import Divisions from './pages/divisions';
import Games from './pages/games';
import Leagues from './pages/leagues';
import Locations from './pages/locations';
import Posts from './pages/posts';
import Pages from './pages/pages';
import Seasons from './pages/seasons';
import Screens from './pages/screens';
import Teams from './pages/teams';
import { previous } from './utils';

export const Routes: FC<RouteComponentProps<{}>> = ({ history }) => {
  useEffect(() => {
    return history.listen(previous.watch)
  }, [])

  return (
    <React.Fragment>
      <Route path="/" exact component={Dashboard}/>
      <Route path="/calendar" component={Calendar}/>
      <Route path="/divisions" component={Divisions}/>
      <Route path="/games" component={Games}/>
      <Route path="/leagues" component={Leagues}/>
      <Route path="/seasons" component={Seasons}/>
      <Route path="/locations" component={Locations}/>
      <Route path="/posts" component={Posts}/>
      <Route path="/pages" component={Pages}/>
      <Route path="/screens" component={Screens}/>
      <Route path="/teams" component={Teams}/>
    </React.Fragment>
  )
}

export default withRouter(Routes);

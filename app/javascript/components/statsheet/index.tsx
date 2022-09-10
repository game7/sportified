import React, { FC, useReducer } from 'react';
import { Tab, Header, Divider } from 'semantic-ui-react';
import { Summary } from './summary';
import { Players } from './players';
import { Goals } from './goals';
import { Penalties } from './penalties';
import { Settings, Team, Game, Goal, Player, Skater, Action, Penalty, Goaltender } from '../common/types'
import { reducer } from './reducer';
import { Goaltending } from './goaltending';
import moment from 'moment';

interface Props {
  settings: Settings;
  game: Game;
  teams: Team[];
  players: Player[];
  skaters: Skater[];
  goals: Goal[];
  penalties: Penalty[];
  goaltenders: Goaltender[];
}

const Statsheet: FC<Props> = ({ settings, game, teams, players, skaters, goals, penalties, goaltenders }) => {

  const [statsheet, dispatch] = useReducer(reducer, {
    settings,
    game,
    teams,
    players,
    skaters,
    goals,
    penalties,
    goaltenders
  })

  const panes = [
    {
      menuItem: 'Summary',
      render: () => <Summary statsheet={statsheet} dispatch={dispatch} />
    },
    {
      menuItem: 'Players',
      render: () => <Players statsheet={statsheet} dispatch={dispatch} />
    },
    {
      menuItem: 'Goals',
      render: () => <Goals statsheet={statsheet} dispatch={dispatch} />
    },
    {
      menuItem: 'Penalties',
      render: () => <Penalties statsheet={statsheet} dispatch={dispatch} />
    },
    {
      menuItem: 'Goaltending',
      render: () => <Goaltending statsheet={statsheet} dispatch={dispatch} />
    }
  ]
  return (
    <React.Fragment>
      <Header as="h2" content={game.summary} subheader={moment(game.startsOn).format("dddd, MMMM Do YYYY, h:mm a")} />
      <Divider />
      <Tab panes={panes} defaultActiveIndex={0} />
    </React.Fragment>
  )
}

export default Statsheet;
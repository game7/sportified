import React, { FC } from 'react';
import { Tab, Header, Grid, Segment } from 'semantic-ui-react';
import { Statsheet, Action } from '../../common/types';
import { GoalsTable } from './goals-table';
import { PeriodsTable } from './periods-table';
import { ShotsTable } from './shots-table';
import { EditShots } from './edit-shots';
import { EditPeriods } from './edit-periods';
import { keyBy }  from 'lodash';

interface Props {
  statsheet: Statsheet;
  dispatch: React.Dispatch<Action>
}

export const Summary: FC<Props> = ({ statsheet, dispatch }) => {
  const { game, teams } = statsheet;
  const teamMap = keyBy(teams, "id")
  const awayTeam = teamMap[game.awayTeamId]
  const homeTeam = teamMap[game.homeTeamId]

  return (
    <Tab.Pane>
      <Segment textAlign="right">
        <EditPeriods statsheet={statsheet} dispatch={dispatch} />
        <EditShots statsheet={statsheet} homeTeam={homeTeam} awayTeam={awayTeam} dispatch={dispatch} />
      </Segment>
      <Header as="h3" content="Periods" />
      <PeriodsTable statsheet={statsheet} />
      
      <Header as="h3" content="Goals" />
      <GoalsTable statsheet={statsheet} homeTeam={homeTeam} awayTeam={awayTeam} />
      
      <Header as="h3" content="Shots" />
      <ShotsTable statsheet={statsheet} homeTeam={homeTeam} awayTeam={awayTeam} />
    </Tab.Pane>
  )

}

import React, { FC } from 'react';
import { Tab, Table, Button, Segment } from 'semantic-ui-react';
import { Statsheet, Action } from '../../common/types';
import { sortBy, keyBy, padStart } from 'lodash';
import { AddGoal } from './add-goal';

interface Props {
  statsheet: Statsheet
  dispatch: React.Dispatch<Action>
}

export const Goals: FC<Props> = ({ statsheet, dispatch }) => { 
  const { game, goals, skaters, settings } = statsheet
  const sorted = sortBy(goals, "period", "minute", "second");
  const teams = statsheet.teams.filter(team => [game.homeTeamId, game.awayTeamId].indexOf(team.id) !== -1)
  const teamMap = keyBy(teams, "id");
  function team(id: number) {
    return team && teamMap[id].name;
  }
  const skaterMap = keyBy(skaters, "id");
  function skater(id: number) {
    const skater = skaterMap[id];
    return skater ? `${skater.jerseyNumber} - ${skater.lastName}, ${skater.firstName}` : id
  }
  async function handleDelete(goalId) {
    const url = `/admin/hockey_statsheets/${settings.id}/goals/${goalId}`
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const response = await fetch(url, { method: 'DELETE', headers: headers })
    if(response.status == 204) {
      dispatch({ type: 'goal/deleted', payload: goalId });
    }
  }
  return (
    <Tab.Pane>
      <Segment textAlign="right">
        <AddGoal settings={settings} teams={teams} skaters={skaters} dispatch={dispatch} />
      </Segment>
      <Table celled>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell content="" />
            <Table.HeaderCell content="PER" textAlign="center" />
            <Table.HeaderCell content="TIME" textAlign="center" />
            <Table.HeaderCell content="TEAM" />
            <Table.HeaderCell content="GOAL" />
            <Table.HeaderCell content="ASSIST" />
            <Table.HeaderCell content="ASSIST" />
            <Table.HeaderCell content="STR" textAlign="center" />
            <Table.HeaderCell content="" />
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {sorted.map((goal, i) => (
            <Table.Row key={goal.id}>
              <Table.Cell collapsing content={i + 1} textAlign="center" />
              <Table.Cell collapsing content={goal.period} textAlign="center" />
              <Table.Cell collapsing content={`${goal.minute}:${padStart(goal.second.toString(), 2, "0")}`} textAlign="center" />
              <Table.Cell content={team(goal.teamId)} />
              <Table.Cell content={skater(goal.scoredById)} />
              <Table.Cell content={skater(goal.assistedById)} />
              <Table.Cell content={skater(goal.alsoAssistedById)} />
              <Table.Cell content={goal.strength} textAlign="center" />
              <Table.Cell collapsing>
                <Button primary content="Delete" onClick={() => handleDelete(goal.id)} />
              </Table.Cell>

            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </Tab.Pane>
  )
}

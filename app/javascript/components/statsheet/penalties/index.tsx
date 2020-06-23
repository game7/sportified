import React, { FC } from 'react'
import { Statsheet, Action } from '../../common/types';
import { Tab, Table, Segment, Button } from 'semantic-ui-react'
import { sortBy, keyBy, padStart } from 'lodash'
import { PenaltyEditor } from './penalty-editor';

interface Props {
  statsheet: Statsheet
  dispatch: React.Dispatch<Action>
}

export const Penalties: FC<Props> = ({ statsheet, dispatch }) => {
  const { game, penalties, skaters, settings } = statsheet
  const sorted = sortBy(penalties, "period", "minute", "second");
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
  async function handleDelete(penaltyId) {
    const url = `/admin/hockey_statsheets/${settings.id}/penalties/${penaltyId}`
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const response = await fetch(url, { method: 'DELETE', headers: headers })
    if(response.status == 204) {
      dispatch({ type: 'penalty/deleted', payload: penaltyId });
    }
  }
  function time(minute, second) {
    if(second == undefined) return "";
    return `${minute}:${padStart(second.toString(), 2, "0")}`
  }
  return (
    <Tab.Pane>
      <Segment textAlign="right">
        <PenaltyEditor settings={settings} teams={teams} skaters={skaters} dispatch={dispatch} />
      </Segment>
      <Table celled>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell content="" />
            <Table.HeaderCell content="PER" textAlign="center" />
            <Table.HeaderCell content="TIME" textAlign="center" />
            <Table.HeaderCell content="TEAM" />
            <Table.HeaderCell content="PLAYER" />
            <Table.HeaderCell content="MIN" textAlign="center" />
            <Table.HeaderCell content="INFRACTION" />
            <Table.HeaderCell content="START" textAlign="center" />
            <Table.HeaderCell content="END" textAlign="center" />            
            <Table.HeaderCell content="" />
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {sorted.map((penalty, i) => (
            <Table.Row key={penalty.id}>
              <Table.Cell collapsing content={i + 1} textAlign="center" />
              <Table.Cell collapsing content={penalty.period} textAlign="center" />
              <Table.Cell collapsing content={time(penalty.minute, penalty.second)} textAlign="center" />
              <Table.Cell content={team(penalty.teamId)} />
              <Table.Cell content={skater(penalty.committedById)} />
              <Table.Cell content={penalty.duration} textAlign="center" />
              <Table.Cell content={`${penalty.infraction} (${penalty.severity})`} />
              <Table.Cell content={time(penalty.startMinute, penalty.startSecond)} textAlign="center" />
              <Table.Cell content={time(penalty.endMinute, penalty.endSecond)} textAlign="center" />
              <Table.Cell collapsing>
                <PenaltyEditor settings={settings} teams={teams} skaters={skaters} penalty={penalty} dispatch={dispatch}/>
                <Button primary content="Delete" onClick={() => handleDelete(penalty.id)} size="mini"/>
              </Table.Cell>

            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </Tab.Pane>
  )

}

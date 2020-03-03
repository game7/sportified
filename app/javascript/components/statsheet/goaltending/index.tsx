import React, { FC } from 'react'
import { Statsheet, Action, Goaltender } from '../../common/types';
import { Tab, Segment, Table, ButtonContent, Button } from 'semantic-ui-react';
import { keyBy } from 'lodash';
import { GoaltenderEditor } from './goaltender-editor';

interface Props {
  statsheet: Statsheet
  dispatch: React.Dispatch<Action>
}

export const Goaltending: FC<Props> = ({ statsheet, dispatch }) => {
  const { settings, goaltenders, players, game } = statsheet;
  const sorted = goaltenders;
  const teams = statsheet.teams.filter(team => [game.homeTeamId, game.awayTeamId].indexOf(team.id) !== -1)
  const teamMap = keyBy(teams, "id");
  function team(id: number) {
    return team && teamMap[id].name;
  }
  function player(g: Goaltender) {
    if(!g.lastName) { return "" }
    return `${g.jerseyNumber} - ${g.lastName}, ${g.firstName}`
  }  
  async function handleDelete(goaltenderId) {
    const url = `/admin/hockey_statsheets/${settings.id}/goaltenders/${goaltenderId}`
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const response = await fetch(url, { method: 'DELETE', headers: headers })
    if(response.ok) {
      dispatch({ type: 'goaltender/deleted', payload: goaltenderId });
    }
  }
  async function handleLoad() {
    const url = `/admin/hockey_statsheets/${settings.id}/goaltenders/autoload`
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const response = await fetch(url, { method: 'POST', headers: headers })
    if(response.ok) {
      const payload = await response.json();
      dispatch({ type: 'goaltenders/loaded', payload });
    }
  }  
  return (
    <Tab.Pane>
      <Segment textAlign="right">
        <GoaltenderEditor settings={settings} teams={teams} players={players} dispatch={dispatch} />
        <Button primary content="Load Goaltenders" onClick={handleLoad} />
      </Segment>
      <Table celled>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell content="TEAM" />
            <Table.HeaderCell content="PLAYER" />
            <Table.HeaderCell content="MINUTES" textAlign="center" />
            <Table.HeaderCell content="SHOTS" textAlign="center" />
            <Table.HeaderCell content="GOALS" textAlign="center" />
            <Table.HeaderCell content="" />
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {sorted.map((g, i) => (
            <Table.Row key={g.id}>
              <Table.Cell content={team(g.teamId)} />
              <Table.Cell content={player(g)} />
              <Table.Cell content={g.minutesPlayed} width="2" textAlign="center" />
              <Table.Cell content={g.shotsAgainst} width="2" textAlign="center" />
              <Table.Cell content={g.goalsAgainst} width="2" textAlign="center" />
              <Table.Cell collapsing>
                <GoaltenderEditor settings={settings} teams={teams} players={players} goaltender={g} dispatch={dispatch} />
                <Button primary size="mini" content="Delete" onClick={() => handleDelete(g.id)} />
              </Table.Cell>

            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </Tab.Pane>
  )

}
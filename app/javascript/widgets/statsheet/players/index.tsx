import React, { FC, useState } from 'react';
import { Statsheet, Settings, Skater, Action, Game, Team } from '../../common/types';
import { Tab, Segment, Grid, Header, Button, Table, Checkbox, Modal, Form } from 'semantic-ui-react'
import { sortBy, keyBy } from 'lodash'
import { AddPlayer } from './add-player';
import { EditPlayer } from './edit-player';

interface Props {
  statsheet: Statsheet
  dispatch: React.Dispatch<Action>
}

export const Players: FC<Props> = ({ statsheet, dispatch }) => {
  const { settings, game, teams, skaters } = statsheet;
  const sorted = sortBy(skaters, "lastName", "firstName")
  const teamMap = keyBy(teams, "id")
  const awayTeam = teamMap[game.awayTeamId]
  const homeTeam = teamMap[game.homeTeamId]

  async function handleLoad() {
    const url = `/admin/hockey_statsheets/${settings.id}/players/load`
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const response = await fetch(url, { method: 'POST', headers: headers })
    if(response.status == 200) {
      const skaters = await response.json()
      dispatch({ type: 'skaters/loaded', payload: skaters });
    }    
  }  

  return (
    <Tab.Pane>
      <Segment textAlign="right">
        <AddPlayer settings={settings} teams={[awayTeam, homeTeam]} dispatch={dispatch} />
        <Button content="Get Missing Players" primary onClick={handleLoad} />
      </Segment>
      <Grid columns={2}>
        <Grid.Column>
          <Header as="h2" content={awayTeam.name} />
          <Roster settings={settings} skaters={sorted.filter(s => s.teamId == game.awayTeamId)} dispatch={dispatch} />
        </Grid.Column>
        <Grid.Column>
          <Header as="h2" content={homeTeam.name} />
          <Roster settings={settings} skaters={sorted.filter(s => s.teamId == game.homeTeamId)} dispatch={dispatch} />
        </Grid.Column>
      </Grid>
    </Tab.Pane>
  )

}

interface RosterProps {
  settings: Settings;
  skaters: Skater[];
  dispatch: React.Dispatch<Action>;
}

const Roster: FC<RosterProps> = ({ settings, skaters, dispatch }) => {

  function bindGamesPlayed(skater: Skater) {
    return async function handleGamesPlayedChange(event, control) {
      const url = `/admin/hockey_statsheets/${settings.id}/players/${skater.id}`;
      const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }   
      const body = JSON.stringify({ hockey_skater_result: { games_played: !!skater.gamesPlayed ? 0 : 1 } })
      const response = await fetch(url, { method: 'PATCH', headers: headers, body: body })
      const payload = await response.json();
      dispatch({ type: 'skater/updated', payload: payload })
    
    }
  }

  async function handleDelete(skaterId) {
    const url = `/admin/hockey_statsheets/${settings.id}/players/${skaterId}`
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const response = await fetch(url, { method: 'DELETE', headers: headers })
    if(response.status == 204) {
      dispatch({ type: 'skater/deleted', payload: skaterId });
    }
  }

  return (
    <Table celled striped>
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell content="GP" textAlign="center" />
          <Table.HeaderCell content="#" textAlign="center" />
          <Table.HeaderCell content="NAME" />
          <Table.HeaderCell content="" />
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {skaters.map(skater => (
          <Table.Row key={skater.id}>
            <Table.Cell textAlign="center">
              <Checkbox checked={skater.gamesPlayed == 1} onChange={bindGamesPlayed(skater)} />
            </Table.Cell>
            <Table.Cell content={skater.jerseyNumber} textAlign="center" />
            <Table.Cell content={`${skater.lastName}, ${skater.firstName}`} />
            <Table.Cell collapsing>
              <EditPlayer settings={settings} skater={skater} dispatch={dispatch} />
              <Button content="Delete" size="mini" primary onClick={() => handleDelete(skater.id)} />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table.Body>
    </Table>
  )
}

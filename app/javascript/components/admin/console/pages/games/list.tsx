import React, { FC, useState, useEffect } from 'react';
import Layout from "../../components/layout";
import { Game, list } from "../../actions/games";
import ActionsDropdown  from "../../components/actions-dropdown"
import { Dropdown, Table, Header, Image, Button } from 'semantic-ui-react'
import { Link } from 'react-router-dom';
import moment from 'moment';

export const GamesList: FC<{}> = () => {

  const [games, setGames] = useState<Game[]>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    setLoading(true)
    list({}).then(games => {
      setGames(games)
      setLoading(false)
    })
  }, [])

  const actions = (<></>)

  return (
    <Layout title="Recent & Upcoming Games" actions={actions}>
      <Table>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>Date</Table.HeaderCell>
            <Table.HeaderCell>Time</Table.HeaderCell>
            <Table.HeaderCell>Summary</Table.HeaderCell>
            <Table.HeaderCell textAlign="center">Actions</Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {games.map(game => (
            <Table.Row key={game.id}>
              <Table.Cell content={moment(game.startsOn).format("ddd M/D/YY")}/>
              <Table.Cell content={moment(game.startsOn).format("h:mm a")} />
              <Table.Cell content={game.summary} />
              <Table.Cell textAlign="center">
                <ActionsDropdown>
                  <Dropdown.Item as={Link} to={`/games/${game.id}/edit`} icon="edit" text="Result" />
                  <Dropdown.Item as={Link} to={`/games/${game.id}/edit`} icon="chart bar" text="Statistics" />
                  <Dropdown.Item as={Link} to={`/games/${game.id}/edit`} icon="print" text="Print" />
                </ActionsDropdown>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </Layout>
  )
}

export default GamesList;


import React, { FC, useState, useEffect } from 'react';
import Layout from "../../components/layout";
import { League, list } from "../../actions/leagues";
import ActionsDropdown  from "../../components/actions-dropdown"
import { Dropdown, Table, Button, Segment, Dimmer, Loader } from 'semantic-ui-react'
import { Link } from 'react-router-dom';

export const LeaguesList: FC<{}> = () => {

  const [leagues, setLocations] = useState<League[]>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    setLoading(true)
    list({}).then(leagues => {
      setLocations(leagues)
      setLoading(false)
    })
  }, [])

  const actions = (
    <Button as={Link} to="/leagues/new" content="New League" icon="plus"/>
  )

  return (
    <Layout title="Leagues" actions={actions} loading={loading}>
      <Table>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>Name</Table.HeaderCell>
            <Table.HeaderCell>Description</Table.HeaderCell>
            <Table.HeaderCell textAlign="center">Actions</Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {leagues.map(league => (
            <Table.Row key={league.id}>
              <Table.Cell>
                <Link to={`/leagues/${league.id}`}>{league.name}</Link>
              </Table.Cell>
              <Table.Cell content={league.description} />
              <Table.Cell textAlign="center">
                <ActionsDropdown>
                  <Dropdown.Item as={Link} to={`/leagues/${league.id}`} icon="dashboard" text="Dashboard" />
                  <Dropdown.Item as={Link} to={`/leagues/${league.id}/edit`} icon="edit" text="Edit" />
                </ActionsDropdown>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </Layout>
  )
}

export default LeaguesList;


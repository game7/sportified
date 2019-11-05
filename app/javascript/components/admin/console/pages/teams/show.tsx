import React, { FC, useState, useEffect } from 'react';
import { RouteComponentProps } from 'react-router';
import Layout from "../../components/layout";
import { Team, find, list } from "../../actions/teams";
import ActionsDropdown  from "../../components/actions-dropdown"
import { Dropdown, Table, Button } from 'semantic-ui-react'
import { Link } from 'react-router-dom';
import { asc } from '../../utils/sort';

export const TeamShow: FC<RouteComponentProps<{ id: number }>> = ({ match, history }) => {
  const {
    id
  } = match.params
  const [team, setTeam] = useState<Team>()
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    setLoading(true)
    find({ id }).then(team => {
      setTeam(team)
      setLoading(false)
    })
  }, [])

  const actions = (
    <Button as={Link} to="/teams/new" content="New Team" icon="plus"/>
  )
  console.log(team)
  return (
    <Layout title={team ? team.name : 'Loading'} actions={actions} loading={loading}>
      <Table>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>Name</Table.HeaderCell>
            <Table.HeaderCell textAlign="center">#</Table.HeaderCell>
            <Table.HeaderCell textAlign="center">Sub</Table.HeaderCell>
            <Table.HeaderCell textAlign="center">Actions</Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {team && asc(team.players, "lastName").map(player => (
            <Table.Row key={player.id}>
              <Table.Cell content={`${player.lastName}, ${player.firstName}`}/>
              <Table.Cell content={player.jerseyNumber} textAlign="center" />
              <Table.Cell content={player.substitute ? 'X' : ''} textAlign="center" />
              <Table.Cell textAlign="center">
                <ActionsDropdown>
                  <Dropdown.Item as={Link} to={`/players/${player.id}/edit`} icon="edit" text="Edit" />
                </ActionsDropdown>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </Layout>
  )
}

export default TeamShow;


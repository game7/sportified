import React, { FC, useState, useEffect } from 'react';
import Layout from "../../components/layout";
import { Team, list } from "../../actions/teams";
import ActionsDropdown  from "../../components/actions-dropdown"
import { Dropdown, Table, Button } from 'semantic-ui-react'
import { Link } from 'react-router-dom';

export const TeamsList: FC<{}> = () => {

  const [teams, setTeams] = useState<Team[]>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    setLoading(true)
    list({}).then(teams => {
      setTeams(teams)
      setLoading(false)
    })
  }, [])

  const actions = (
    <Button as={Link} to="/teams/new" content="New Team" icon="plus"/>
  )

  return (
    <Layout title="Teams" actions={actions}>
      <Table>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>Name</Table.HeaderCell>
            <Table.HeaderCell>Short Name</Table.HeaderCell>
            <Table.HeaderCell textAlign="center">Actions</Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {teams.map(team => (
            <Table.Row key={team.id}>
              <Table.Cell content={team.name}/>
              <Table.Cell content={team.shortName} />
              <Table.Cell textAlign="center">
                <ActionsDropdown>
                  <Dropdown.Item as={Link} to={`/teams/${team.id}/edit`} icon="edit" text="Edit" />
                </ActionsDropdown>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </Layout>
  )
}

export default TeamsList;


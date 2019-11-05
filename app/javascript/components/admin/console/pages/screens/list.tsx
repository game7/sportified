import React, { FC, useState, useEffect } from 'react';
import Layout from "../../components/layout";
import { Screen, list } from "../../actions/screens";
import ActionsDropdown  from "../../components/actions-dropdown"
import { Dropdown, Table, Header, Image, Button } from 'semantic-ui-react'
import { Link } from 'react-router-dom';
import { destroy } from '../../actions/screens'

export const ScreensList: FC<{}> = () => {

  const [screens, setScreens] = useState<Screen[]>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    setLoading(true)
    list({}).then(screens => {
      setScreens(screens)
      setLoading(false)
    })
  }, [])

  const actions = (
    <Button as={Link} to="/screens/new" content="New Screen" icon="plus"/>
  )

  function handleDelete(id) {
    if(destroy({ id })) {
      setScreens(screens.filter(s => s.id !== id))
    }
  }

  return (
    <Layout title="Screens" actions={actions}>
      <Table>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>Name</Table.HeaderCell>
            <Table.HeaderCell>Location</Table.HeaderCell>
            <Table.HeaderCell textAlign="center">Actions</Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {screens.map(screen => (
            <Table.Row key={screen.id}>
              <Table.Cell content={screen.name}/>
              <Table.Cell content={screen.location && screen.location.name} />
              <Table.Cell textAlign="center">
                <ActionsDropdown>
                  <Dropdown.Item as={Link} to={`/screens/${screen.id}/edit`} icon="edit" text="Edit" />
                  <Dropdown.Item content="Delete" icon="trash" onClick={() => { handleDelete(screen.id) }} />
                </ActionsDropdown>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </Layout>
  )
}

export default ScreensList;


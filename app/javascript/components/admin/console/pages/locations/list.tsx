import React, { FC, useState, useEffect } from 'react';
import Layout from "../../components/layout";
import { Location, list } from "../../actions/locations";
import ActionsDropdown  from "../../components/actions-dropdown"
import { Dropdown, Table, Header, Image, Button } from 'semantic-ui-react'
import { Link } from 'react-router-dom';
import Locations from '.';

export const LocationsList: FC<{}> = () => {

  const [locations, setLocations] = useState<Location[]>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    setLoading(true)
    list({}).then(locations => {
      setLocations(locations)
      setLoading(false)
    })
  }, [])

  const actions = (
    <Button as={Link} to="/locations/new" content="New Location" icon="plus"/>
  )

  return (
    <Layout title="Locations" actions={actions}>
      <Table>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>Name</Table.HeaderCell>
            <Table.HeaderCell>Short Name</Table.HeaderCell>
            <Table.HeaderCell textAlign="center">Actions</Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {locations.map(location => (
            <Table.Row key={location.id}>
              <Table.Cell content={location.name}/>
              <Table.Cell content={location.shortName} />
              <Table.Cell textAlign="center">
                <ActionsDropdown>
                  <Dropdown.Item as={Link} to={`/locations/${location.id}/edit`} icon="edit" text="Edit" />
                </ActionsDropdown>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </Layout>
  )
}

export default LocationsList;


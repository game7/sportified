import React, { FC, useState, useEffect } from 'react'
import { RouteComponentProps, Link } from 'react-router-dom';
import { Registration } from '../../data';
import { Format } from '../../utils';
import { Table } from 'semantic-ui-react';

interface Props extends RouteComponentProps<{}> {

}

const RegistrationsList: FC<Props> = () => {

  const [registrations, setRegistrations] = useState<Registration[]>([]);

  useEffect(() => {
    fetch('/registrar/api/registrations')
    .then(response => response.json())
    .then<Registration[]>(payload => payload as Registration[])
    .then(registrations => {
      setRegistrations(registrations)
    });
  }, [])

  return (
    <div>
      <Table>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>Id</Table.HeaderCell>
            <Table.HeaderCell>Name</Table.HeaderCell>
            <Table.HeaderCell>Price</Table.HeaderCell>
            <Table.HeaderCell>Status</Table.HeaderCell>
            <Table.HeaderCell>Updated</Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {registrations.map(r => (
            <Table.Row key={r.id}>
              <Table.Cell>
                <Link to={`/registrations/${r.id}`}>{r.id}</Link>
              </Table.Cell>
              <Table.Cell>{`${r.firstName} ${r.lastName}`}</Table.Cell>
              <Table.Cell>{`$${Format.currency(r.price)}`}</Table.Cell>
              <Table.Cell>{r.status}</Table.Cell>
              <Table.Cell>{Format.timeAgo(r.updatedAt)}</Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </div>
  )

}

export default RegistrationsList

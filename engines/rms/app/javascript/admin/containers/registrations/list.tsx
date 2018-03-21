import * as React from 'react'
import { RouteComponentProps, Link } from 'react-router-dom';
import { Registration } from '../../data';
import { Format } from '../../utils';
import { Table } from 'semantic-ui-react';

interface Props extends RouteComponentProps<{}> {

}

interface State {
  registrations: Registration[];
}

export default class RegistrationsList extends React.Component<Props,State> {

  componentWillMount() {
    this.setState({ registrations: [] }, () => {
      fetch('/registrar/api/registrations')
        .then(response => response.json())
        .then<Registration[]>(payload => payload as Registration[])
        .then(registrations => {
          this.setState({ registrations })
        });
    });
  }

  render() {
    const { registrations = ([] as Registration[])} = this.state;
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

}

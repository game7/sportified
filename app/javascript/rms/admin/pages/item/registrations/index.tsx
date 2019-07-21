import React, { useState, FC } from 'react';
import { RouteComponentProps } from 'react-router-dom';
import { Item, Registration } from '../../../data';
import { Format, Sort, Export } from '../../../utils';
import { Table, Button } from 'semantic-ui-react';

interface Props extends RouteComponentProps<{}> {
  item: Item
}

export const ItemRegistrations: FC<Props> = (props) => {

  const { item = ({} as Item) } = props;
  const { registrations = ([] as Registration[])} = item;
  const sorted = Sort(registrations).desc(r => r.id);
  const [ exporting, setExporting ] = useState(false);

  const handleExportClick = () => {
    setExporting(true);
    fetch(`/registrar/api/items/${item.id}/extract`)
      .then(response => response.json())
      .then<any[]>(payload => payload)
      .then(rows => {
        const csv = rows.map(r => r.join(',')).join('\n');
        Export('regsitrations.csv', rows);
        setExporting(false);
      });
  }


  return (
    <div>
      <Button onClick={handleExportClick} loading={exporting}>
        Export All
      </Button>
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
          {sorted.map(r => (
            <Table.Row key={r.id}>
              <Table.Cell>{r.id}</Table.Cell>
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

export default ItemRegistrations;

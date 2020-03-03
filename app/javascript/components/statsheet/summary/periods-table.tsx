import React, { FC } from 'react';
import { Table } from 'semantic-ui-react';
import { Statsheet } from '../../common/types';

export const PeriodsTable: FC<{ statsheet: Statsheet }> = ({ statsheet }) => {
  const { settings } = statsheet;
  const s = settings;
  return (
    <Table celled>
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell content=""/>
          <Table.HeaderCell content="1" textAlign="center" />
          <Table.HeaderCell content="2" textAlign="center" />
          <Table.HeaderCell content="3" textAlign="center" />
          <Table.HeaderCell content="OT" textAlign="center" />
          <Table.HeaderCell content="Total" textAlign="center" />
        </Table.Row>
      </Table.Header>
      <Table.Body>
        <Table.Row>
          <Table.Cell content="Duration"/>
          <Table.Cell width="2" content={s.min1} textAlign="center" />
          <Table.Cell width="2" content={s.min2} textAlign="center" />
          <Table.Cell width="2" content={s.min3} textAlign="center" />
          <Table.Cell width="2" content={s.minOt} textAlign="center" />
          <Table.Cell width="2" content={s.min1 + s.min2 + s.min3 + s.minOt} textAlign="center" />
        </Table.Row>
      </Table.Body>
    </Table>
  )
}

import React, { FC } from 'react';
import { Table } from 'semantic-ui-react';
import { Statsheet, Team, } from '../../common/types';

export const ShotsTable: FC<{ statsheet: Statsheet, homeTeam: Team, awayTeam: Team }> = ({ statsheet, homeTeam, awayTeam }) => {
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
          <Table.Cell content={awayTeam.name} />
          <Table.Cell width="2" content={s.awayShots1} textAlign="center" />
          <Table.Cell width="2" content={s.awayShots2} textAlign="center" />
          <Table.Cell width="2" content={s.awayShots3} textAlign="center" />
          <Table.Cell width="2" content={s.awayShotsOt} textAlign="center" />
          <Table.Cell width="2" content={s.awayShots1 + s.awayShots2 + s.awayShots3 + s.awayShotsOt} textAlign="center" />
        </Table.Row>
        <Table.Row>
          <Table.Cell content={homeTeam.name} />
          <Table.Cell width="2" content={s.homeShots1} textAlign="center" />
          <Table.Cell width="2" content={s.homeShots2} textAlign="center" />
          <Table.Cell width="2" content={s.homeShots3} textAlign="center" />
          <Table.Cell width="2" content={s.homeShotsOt} textAlign="center" />
          <Table.Cell width="2" content={s.homeShots1 + s.homeShots2 + s.homeShots3 + s.homeShotsOt} textAlign="center" />
        </Table.Row>
      </Table.Body>
    </Table>
  )
}

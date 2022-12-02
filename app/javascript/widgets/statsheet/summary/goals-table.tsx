import React, { FC } from 'react';
import { Table } from 'semantic-ui-react';
import { Statsheet, Team } from '../../common/types';
import { groupBy }  from 'lodash';

export const GoalsTable: FC<{ statsheet: Statsheet, homeTeam: Team, awayTeam: Team }> = ({ statsheet, homeTeam, awayTeam }) => {
  const { settings, goals } = statsheet;
  const s = settings;
  const awayGoals = goals.filter(g => g.teamId === awayTeam.id)
  const homeGoals = goals.filter(g => g.teamId === homeTeam.id)
  const awayGoalsByPeriod = groupBy(awayGoals, "period")
  const homeGoalsByPeriod = groupBy(homeGoals, "period")
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
          <Table.Cell width="2" content={(awayGoalsByPeriod["1"] || []).length} textAlign="center" />
          <Table.Cell width="2" content={(awayGoalsByPeriod["2"] || []).length} textAlign="center" />
          <Table.Cell width="2" content={(awayGoalsByPeriod["3"] || []).length} textAlign="center" />
          <Table.Cell width="2" content={(awayGoalsByPeriod["OT"] || []).length} textAlign="center" />
          <Table.Cell width="2" content={awayGoals.length} textAlign="center" />
        </Table.Row>
        <Table.Row>
          <Table.Cell content={homeTeam.name} />
          <Table.Cell width="2" content={(homeGoalsByPeriod["1"] || []).length} textAlign="center" />
          <Table.Cell width="2" content={(homeGoalsByPeriod["2"] || []).length} textAlign="center" />
          <Table.Cell width="2" content={(homeGoalsByPeriod["3"] || []).length} textAlign="center" />
          <Table.Cell width="2" content={(homeGoalsByPeriod["OT"] || []).length} textAlign="center" />
          <Table.Cell width="2" content={homeGoals.length} textAlign="center" />
        </Table.Row>
      </Table.Body>
    </Table>
  )
}


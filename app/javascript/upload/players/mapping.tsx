import * as _ from 'lodash';
import { useEffect, useState } from 'react';
import { DropdownProps, Select, Table } from 'semantic-ui-react';
import { Team } from '../common/store';
import { Column, Header, Map, row, storage } from './common';


export function makeTeamMaps(columns: Column[], rows: row[], hasHeader: boolean): Map[] {
  if (hasHeader) [, ...rows] = rows;
  const positions = [
    columns.findIndex(col => col.property == 'team')
  ];
  const all = rows.map(row => positions.map(p => (row[p]))).reduce((prev, curr) => prev.concat(curr));
  const uniq = _.uniq(all) as string[];
  const maps = uniq.map(item => ({ key: item }));
  return maps;
}

export function findTeams(maps: Map[], teams: Team[]): Map[] {
  return maps.map(map => {
    let team = teams.filter(t => t.name.toLowerCase().indexOf(map.key?.toLowerCase()) != -1)[0] || ({} as Team);
    return {
      key: map.key,
      id: team.id,
      name: team.name
    } as Map;
  });
}


export default function Mapping() {
  const [state, setState] = useState(storage.load());

  useEffect(() => storage.save(state), [state])

  useEffect(() => {
    if (state.teamMaps) { return }
    const { columns, rows, hasHeader, teams = [], seasonId, divisionId } = state;
    const teamMaps = findTeams(makeTeamMaps(columns, rows, hasHeader), teams.filter(t => t.seasonId == seasonId && t.divisionId == divisionId));
    setState(state => ({
      ...state,
      teamMaps
    }))
  }, [])

  const canMoveNext = (() => {
    const { teamMaps = [] } = state;
    const maps = [...teamMaps];
    return maps.every(map => map.id);
  })()

  console.log(JSON.stringify(state.teamMaps, null, 2))

  function handleTeamMapChange(key: string) {
    return function teamMapChangeHandler(_, data: DropdownProps) {
      const id = data.value as number;
      const team = state.teams.filter(t => t.id == id)[0]
      const { name } = team;
      const maps = (Object.assign([], state.teamMaps) as Map[]).map(map => {
        if (map.key == key) {
          map.id = id;
          map.name = name;
        }
        return map;
      });
      setState(state => ({ ...state, teamMaps: maps }))
    }
  }

  const teams: Team[] = (() => {
    const { teams = [], seasonId, divisionId } = state;
    return teams.filter((team) => {
      return team.seasonId == seasonId && team.divisionId == divisionId;
    });
  })();



  return (
    <div>
      <Header
        title="Mapping"
        canBack={true}
        backUrl="/players/columns"
        canNext={canMoveNext}
        nextUrl="/players/review"
      />
      <div className="row">
        <div className="col-sm-6">
          <h3>Teams</h3>
          <Maps
            maps={state.teamMaps}
            options={teams}
            onChange={handleTeamMapChange} />
        </div>
      </div>
    </div>
  );
}

type OnMapChange = (key: string) => (event: any, data: DropdownProps) => void;

interface MapsProps {
  maps: Map[];
  options: any[];
  onChange: OnMapChange
}

const Maps = (props: MapsProps) => {
  const {
    maps = [],
    options = [],
    onChange
  } = props;
  return (
    <Table celled striped attached>
      <Table.Body>
        {maps.map((map: Map) => (
          <Table.Row key={map.key || ""}>
            <Table.Cell width="4">{map.key}</Table.Cell>
            <Table.Cell width="12">
              <Select
                value={map.id}
                onChange={onChange(map.key)}
                options={[{ key: 'blank' }, ...options.map(opt => ({ value: opt.id, text: opt.name }))]}
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table.Body>
    </Table>
  );
}

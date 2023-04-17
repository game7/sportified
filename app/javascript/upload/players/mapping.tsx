import * as _ from "lodash";
import { useEffect } from "react";
import { DropdownProps, Select, Table } from "semantic-ui-react";
import { Store, Team } from "../common/store";
import { Column, Header, Map, row, useImportState } from "./common";

export function makeTeamMaps(
  columns: Column[],
  rows: row[],
  hasHeader: boolean
): Map[] {
  if (hasHeader) [, ...rows] = rows;
  const positions = [columns.findIndex((col) => col.property == "team")];
  const all = rows
    .map((row) => positions.map((p) => row[p]))
    .reduce((prev, curr) => prev.concat(curr));
  const uniq = _.uniq(all) as string[];
  const maps = uniq.map((item) => ({ key: item }));
  return maps;
}

export function findTeams(maps: Map[], teams: Team[]): Map[] {
  return maps.map((map) => {
    let team =
      teams.filter(
        (t) => t.name.toLowerCase().indexOf(map.key.toLowerCase()) != -1
      )[0] || ({} as Team);
    return {
      key: map.key,
      id: team.id,
      name: team.name,
    } as Map;
  });
}

export function makeLocationMaps(
  columns: Column[],
  rows: row[],
  hasHeader: boolean
): Map[] {
  if (hasHeader) [, ...rows] = rows;
  const index = columns.findIndex((col) => col.property == "location");
  const all = rows.map((row) => row[index]);
  const uniq = _.uniq(all) as string[];
  const maps = uniq.map((item) => ({ key: item }));
  return maps;
}

export default function MappingPage() {
  const [state, setState] = useImportState();
  const { columns = [], rows = [], hasHeader = false, teamMaps = [] } = state;

  useEffect(() => {
    const updated = { ...state };

    if (teamMaps.length == 0) {
      updated.teamMaps = findTeams(
        makeTeamMaps(columns, rows, hasHeader),
        state.teams?.filter(
          (t) =>
            t.seasonId == state.seasonId && t.divisionId == state.divisionId
        ) || []
      );
    }

    Promise.all([Store.teams(), Store.locations()]).then((results) => {
      setState({
        ...updated,
        teams: results[0] as Team[],
      });
    });
  }, []);

  const canMoveNext: boolean = (() => {
    if (!state) return false;
    const maps = [...teamMaps];
    return maps.every((map) => map.id);
  })();

  const teams: Team[] = (() => {
    const { teams = [], seasonId, divisionId } = state;
    return teams.filter((team) => {
      return team.seasonId == seasonId && team.divisionId == divisionId;
    });
  })();

  function handleTeamMapChange(key: string) {
    return (_event: any, data: DropdownProps) => {
      const id = data.value as number;
      const { name } = state.teams?.filter((t) => t.id == id)[0] || {};
      const maps = (Object.assign([], teamMaps) as Map[]).map((map) => {
        if (map.key == key) {
          map.id = id;
          map.name = name;
        }
        return map;
      });
      setState({ ...state, teamMaps: maps });
    };
  }

  return (
    <div>
      <Header
        title="Mapping"
        canBack={true}
        backUrl="/players/columns"
        canNext={canMoveNext}
        nextUrl="/players/review"
      />

      <h3 className="ui top attached header">Teams</h3>
      <Maps maps={teamMaps} options={teams} onChange={handleTeamMapChange} />
    </div>
  );
}

type OnMapChange = (key: string) => (event: any, data: DropdownProps) => void;

interface MapsProps {
  maps: Map[];
  options: any[];
  onChange: OnMapChange;
}

const Maps = (props: MapsProps) => {
  const { maps = [], options = [], onChange } = props;
  return (
    <Table celled striped attached>
      <Table.Body>
        {maps.map((map: Map) => (
          <Table.Row key={map.key}>
            <Table.Cell width="4">{map.key}</Table.Cell>
            <Table.Cell width="12">
              <Select
                value={map.id}
                onChange={onChange(map.key)}
                options={[
                  { key: "blank" },
                  ...options.map((opt) => ({ value: opt.id, text: opt.name })),
                ]}
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table.Body>
    </Table>
  );
};

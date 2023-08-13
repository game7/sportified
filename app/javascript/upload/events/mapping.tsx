import * as _ from "lodash";
import { useEffect } from "react";
import { DropdownProps, Select, Table } from "semantic-ui-react";
import { Store } from "../common/store";
import { Column, Header, Map, row, useImportState } from "./common";

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
  const {
    columns = [],
    rows = [],
    hasHeader = false,
    locations = [],
    teamMaps = [],
    locationMaps = [],
  } = state;

  useEffect(() => {
    const updated = { ...state };

    if (locationMaps.length == 0) {
      updated.locationMaps = makeLocationMaps(columns, rows, hasHeader);
    }
    Store.locations().then((locations) => {
      setState({
        ...updated,
        locations,
      });
    });
  }, []);

  const canMoveNext: boolean = (() => {
    if (!state) return false;
    const maps = [...teamMaps, ...locationMaps];
    return maps.every((map) => map.id);
  })();

  function handleLocationMapChange(key: string) {
    return (_event: any, data: DropdownProps) => {
      const id = data.value as number;
      const { name } = locations.filter((l) => l.id == id)[0];
      const maps = (Object.assign([], locationMaps) as Map[]).map((map) => {
        if (map.key == key) {
          map.id = id;
          map.name = name;
        }
        return map;
      });
      setState({ ...state, locationMaps: maps });
    };
  }

  return (
    <div>
      <Header
        title="Mapping"
        canBack={true}
        backUrl="/events/columns"
        canNext={canMoveNext}
        nextUrl="/events/review"
      />
      <h3 className="ui top attached header">Locations</h3>
      <Maps
        maps={locationMaps}
        options={locations}
        onChange={handleLocationMapChange}
      />
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

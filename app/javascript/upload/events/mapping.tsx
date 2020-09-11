import * as React from 'react';
import { Component } from 'react';
import * as _ from 'lodash';
import { IImportState, Header, row, storage, Map, Column } from './common';
import { Store, Team, Location } from '../common/store';
import { Table, Select, DropdownProps } from 'semantic-ui-react';



export function makeLocationMaps(columns: Column[], rows: row[], hasHeader: boolean): Map[] {
  if(hasHeader) [ , ...rows] = rows;
  const index = columns.findIndex(col => col.property == 'location');
  const all = rows.map(row => row[index]);
  const uniq = _.uniq(all) as string[];
  const maps = uniq.map(item => ({ key: item }));
  return maps;
}

export default class Mapping extends Component<{},IImportState> {

  componentDidMount() {
    let state = storage.load();
    const { columns, rows, hasHeader } = state;
    if(!state.locationMaps) {
      state.locationMaps = makeLocationMaps(columns, rows, hasHeader);
    }
    Promise.all([
      Store.locations()
    ]).then(results => {
      this.setStateAndSave({
        locations: results[0] as Location[],
        ...state
      });
    });
  }

  get canMoveNext(): boolean {
    const state = this.state;
    if(!state) return false;
    const { locationMaps } = state;
    const maps = [...locationMaps];
    return maps.every(map => map.id && map.id != '');
  }

  setStateAndSave = (state: IImportState) => {
    this.setState(state, () => {
      storage.save(state);
    })
  }

  

  handleLocationMapChange = (key: string) => (event: any, data: DropdownProps) => {
    const id = data.value as string | number;
    const { name } = this.state.locations.filter(l => l.id == id)[0]
    const maps = (Object.assign([], this.state.locationMaps) as Map[]).map(map => {
      if(map.key == key) {
        map.id = id; 
        map.name = name;
      }
      return map;
    });
    this.setState({ locationMaps: maps }, () => storage.save(this.state));
  }

  get teams(): Team[] {
    const state = (this.state || {});
    const { teams = [], seasonId, divisionId } = state;
    return teams.filter((team) => {
      return team.seasonId == seasonId && team.divisionId == divisionId;
    });
  }

  render() {
    const state = (this.state || {});
    
    console.log(state.locationMaps)
    console.log(state.locations)

    return (
      <div>
        <Header
          title="Mapping"
          canBack={true}
          backUrl="/events/columns"
          canNext={this.canMoveNext}
          nextUrl="/events/review"
        />
        <div className="row">
          <div className="col-sm-6">
            <h3>Locations</h3>
            <Maps
              maps={state.locationMaps}
              options={state.locations}
              onChange={this.handleLocationMapChange}/>
          </div>
        </div>
      </div>
    );
  }
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
    <Table celled striped>
      <Table.Body>
        {maps.map((map: Map)=> (
          <Table.Row key={map.key}>
            <Table.Cell width="8">{map.key}</Table.Cell>
            <Table.Cell width="8">
              <Select
                value={map.id}
                onChange={onChange(map.key)}
                options={[ { key: 'blank' }, ...options.map(opt => ({ value: opt.id, text: opt.name }))]}
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table.Body>
    </Table>
  );
}

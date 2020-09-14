import * as React from 'react';
import { Component } from 'react';
import * as _ from 'lodash';
import { IImportState, Header, row, storage, Map, Column } from './common';
import { Store, Team, Location } from '../common/store';
import { Table, Select, DropdownProps } from 'semantic-ui-react';


export function makeTeamMaps(columns: Column[], rows: row[], hasHeader: boolean): Map[] {
  if(hasHeader) [ , ...rows] = rows;
  const positions = [
    columns.findIndex(col => col.property == 'homeTeam'),
    columns.findIndex(col => col.property == 'awayTeam')
  ];
  const all = rows.map(row => positions.map(p => row[p])).reduce((prev, curr) => prev.concat(curr));
  const uniq = _.uniq(all) as string[];
  const maps = uniq.map(item => ({ key: item }));
  return maps;
}

export function findTeams(maps: Map[], teams: Team[]) : Map[] {
  return maps.map(map => {
    let team = teams.filter(t => t.name.toLowerCase().indexOf(map.key.toLowerCase()) != -1)[0] || ({} as Team);
    return {
      key: map.key,
      id: team.id,
      name: team.name
    } as Map;
  });
}

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
    if(!state.teamMaps) {
      state.teamMaps = findTeams(makeTeamMaps(columns, rows, hasHeader), state.teams.filter(t => t.seasonId == state.seasonId && t.divisionId == state.divisionId));
    }    
    if(!state.locationMaps) {
      state.locationMaps = makeLocationMaps(columns, rows, hasHeader);
    }
    Promise.all([
      Store.teams(),
      Store.locations()
    ]).then(results => {
      this.setStateAndSave({
        teams: results[0] as Team[],
        locations: results[1] as Location[],
        ...state
      });
    });
  }

  get canMoveNext(): boolean {
    const state = this.state;
    if(!state) return false;
    const { teamMaps, locationMaps} = state;
    const maps = [...teamMaps, ...locationMaps];
    return maps.every(map => map.id);
  }

  setStateAndSave = (state: IImportState) => {
    this.setState(state, () => {
      storage.save(state);
    })
  }
 
  handleTeamMapChange = (key: string) => (_event: any, data: DropdownProps) => {
    const id = data.value as number;
    const { name } = this.state.teams.filter(t => t.id == id)[0]
    const maps = (Object.assign([], this.state.teamMaps) as Map[]).map(map => {
      if(map.key == key) {
        map.id = id;
        map.name = name;
      }
      return map;
    });
    this.setState({ teamMaps: maps }, () => storage.save(this.state));
  }

  handleLocationMapChange = (key: string) => (_event: any, data: DropdownProps) => {
    const id = data.value as number;
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
          backUrl="/games/columns"
          canNext={this.canMoveNext}
          nextUrl="/games/review"
        />
        <h3 className="ui top attached header">Locations</h3>
        <Maps
          maps={state.locationMaps}
          options={state.locations}
          onChange={this.handleLocationMapChange}/>
        <h3 className="ui top attached header">Teams</h3>      
        <Maps
          maps={state.teamMaps}
          options={this.teams}
          onChange={this.handleTeamMapChange} />            
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
    <Table celled striped attached>
      <Table.Body>
        {maps.map((map: Map)=> (
          <Table.Row key={map.key}>
            <Table.Cell width="4">{map.key}</Table.Cell>
            <Table.Cell width="12">
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

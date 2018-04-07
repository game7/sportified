import * as React from 'react';
import { Component } from 'react';
import * as _ from 'lodash';
import { IImportState, Header, row, storage, Map, Column } from './common';
import { Store, Team, Location } from '../common/store';



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

  handleLocationMapChange = (key: string) => (event: any) => {
    const id = event.target.value;
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

type OnMapChange = (key: string) => (event: any) => void;

interface MapsProps {
  maps: Map[];
  options: any[];
  onChange: OnMapChange
}

const Maps = (props: MapsProps) => {
  console.log(props)
  const {
    maps = [],
    options = [],
    onChange
  } = props;
  return (
    <table className="table table-bordered">
      <tbody>
        {maps.map((map: Map)=> (
          <tr key={map.key}>
            <td style={{width: '50%'}}>{map.key}</td>
            <td style={{width: '50%'}}>
              <select className="form-control"
                value={map.id}
                onChange={onChange(map.key)}>
                <option value=""></option>
                {options.map(opt => (
                  <option key={opt.id} value={opt.id}>{opt.name}</option>
                ))}
              </select>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

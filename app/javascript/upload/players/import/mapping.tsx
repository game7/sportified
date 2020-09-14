import * as React from 'react';
import { Component } from 'react';
import * as _ from 'lodash';
import { IImportState, Header, row, storage, Map, Column } from './common';
import { Store, Team } from '../../common/store';


export function makeTeamMaps(columns: Column[], rows: row[], hasHeader: boolean): Map[] {
  if(hasHeader) [ , ...rows] = rows;
  const positions = [
    columns.findIndex(col => col.property == 'team')
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

const initialState = {};

export default class Mapping extends Component<{},IImportState> {

  readonly state: IImportState = initialState;
  private mounted: boolean = false;

  componentDidMount() {
    this.mounted = true;
    const state = storage.load();
    const { columns, rows, hasHeader, teams = [], seasonId, divisionId } = state;
    const teamMaps = findTeams(makeTeamMaps(columns, rows, hasHeader), teams.filter(t => t.seasonId == seasonId && t.divisionId == divisionId));
    this.setState({
      ...state,
      teamMaps
    })
    Store.teams().then(teams => {
      if(this.mounted) {
        this.setStateAndSave({ teams });
      }
    });
  }

  componentWillUnmount() {
    this.mounted = false;
  }

  get canMoveNext(): boolean {
    const state = (this.state || {});
    const { teamMaps = [] } = state;
    const maps = [...teamMaps];
    return maps.every(map => map.id);
  }

  setStateAndSave = (state: IImportState) => {
    this.setState(state, () => {
      storage.save(this.state);
    })
  }

  handleTeamMapChange = (key: string) => (event: any) => {
    const id = event.target.value;
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

  get teams(): Team[] {
    const { teams = [], seasonId, divisionId } = this.state;
    return teams.filter((team) => {
      return team.seasonId == seasonId && team.divisionId == divisionId;
    });
  }

  render() {
    return (
      <div>
        <Header
          title="Mapping"
          canBack={true}
          backUrl="/players/import/columns"
          canNext={this.canMoveNext}
          nextUrl="/players/import/review"
        />
        <div className="row">
          <div className="col-sm-6">
            <h3>Teams</h3>
            <Maps
              maps={this.state.teamMaps}
              options={this.teams}
              onChange={this.handleTeamMapChange} />
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

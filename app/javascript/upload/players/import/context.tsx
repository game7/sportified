import * as React from 'react';
import { Component } from 'react';
import * as _ from 'lodash';
import { IImportState, Header, row, storage, Map, Column } from './common';
import { Tenant, Store, League, Season, Division } from '../../common/store';
import { Select, Form, SelectProps } from 'semantic-ui-react';

export function makeColumns(row: row): Column[] {
  return row.map(col => {
    return {
      pattern: col
    }
  }) as Column[];
}

export default class Context extends Component<{},IImportState> {

  componentDidMount() {
    let state = storage.load();
    this.setState(state);
    Promise.all([
      Store.leagues(),
      Store.seasons(),
      Store.divisions(),
      Store.teams()
    ]).then(results => {
      this.setStateAndSave({
        leagues: results[0],
        seasons: results[1],
        divisions: results[2],
        teams: results[3],
        ...state
      })
    })
  }

  handleLeagueChange = (_event, data: SelectProps) => {
    this.setStateAndSave({
      leagueId: data.value as number,
      seasonId: undefined,
      divisionId: undefined
    });
  }

  handleSeasonChange = (_event, data: SelectProps) => {
    this.setStateAndSave({ seasonId: data.value as number });
  }

  handleDivisionChange = (_event, data: SelectProps) => {
    this.setStateAndSave({ divisionId: data.value as number })
  }

  setStateAndSave = (state: IImportState) => {
    this.setState(state, () => {
      storage.save(this.state);
    })
  }

  handleColumnChange = (key: string) => (event: any) => {
    const value = event.target.value;
    const state = Object.assign({}, this.state);
    const columns = state.columns.map((column, i) => {
      if (column.pattern == key) {
        column.property = value;
      }
      return column;
    })
    this.setState({ columns: columns }, () => storage.save(this.state));
  }

  render() {
    const state = (this.state || {}) as IImportState
    const { leagueId, seasonId, divisionId } = state;
    const { leagues = [], seasons = [], divisions = [] } = state;
    const canMoveNext = !!state.seasonId && !!state.divisionId;

    const leagueOptions = leagues.map(l => ({ text: l.name, value: l.id }))
    const seasonOptions = seasons.filter(s => s.programId == leagueId).map(s => ({ name: s.name, value: s.id }))
    const divisionOptions = divisions.filter(d => d.programId == leagueId).map(d => ({ name: d.name, value: d.id }))

    console.log(state)

    return (
      <div>
        <Header
          title="Context"
          canBack={false}
          canNext={canMoveNext}
          nextUrl="/games/import/file"
        />
        <Form>
          <Form.Field control={Select} label="League" value={leagueId} options={leagueOptions} onChange={this.handleLeagueChange} />
          <Form.Field control={Select} label="Season" value={seasonId} options={seasonOptions} onChange={this.handleSeasonChange} />
          <Form.Field control={Select} label="Division" value={divisionId} options={divisionOptions} onChange={this.handleDivisionChange} />
        </Form>
      </div>
    );
  }
}


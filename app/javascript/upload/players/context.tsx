import { useEffect, useState } from 'react';
import { Form, Select, SelectProps } from 'semantic-ui-react';
import { Store } from '../common/store';
import { Header, storage } from './common';


export default function Context() {
  const [state, setState] = useState(storage.load())

  useEffect(() => {
    storage.save(state)
  }, [state])

  useEffect(() => {
    Promise.all([
      Store.leagues(),
      Store.seasons(),
      Store.divisions(),
      Store.teams()
    ]).then(results => {
      setState({
        ...state,
        leagues: results[0],
        seasons: results[1],
        divisions: results[2],
        teams: results[3]
      })
    })
  }, [])

  const { leagueId, seasonId, divisionId } = state;
  const { leagues = [], seasons = [], divisions = [] } = state;
  const canMoveNext = !!state.seasonId && !!state.divisionId;

  const leagueOptions = leagues.map(l => ({ text: l.name, value: l.id }))
  const seasonOptions = seasons.filter(s => s.programId == leagueId).map(s => ({ text: s.name, value: s.id }))
  const divisionOptions = divisions.filter(d => d.programId == leagueId).map(d => ({ text: d.name, value: d.id }))

  function handleLeagueChange(_, data: SelectProps) {
    setState(state => ({
      ...state,
      leagueId: data.value as number,
      seasonId: null,
      divisionId: null
    }))
  }

  function handleSeasonChange(_, data: SelectProps) {
    setState(state => ({ ...state, seasonId: data.value as number }));
  }

  function handleDivisionChange(_, data: SelectProps) {
    setState(state => ({ ...state, divisionId: data.value as number }));
  }

  return (
    <div>
      <Header
        title="Context"
        canBack={false}
        canNext={canMoveNext}
        nextUrl="/players/file"
      />
      <Form>
        <Form.Field control={Select} label="League" value={leagueId} options={leagueOptions} onChange={handleLeagueChange} />
        <Form.Field control={Select} label="Season" value={seasonId} options={seasonOptions} onChange={handleSeasonChange} />
        <Form.Field control={Select} label="Division" value={divisionId} options={divisionOptions} onChange={handleDivisionChange} />
      </Form>
    </div>
  );
}

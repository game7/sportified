import { useEffect } from "react";
import { Form, Select, SelectProps } from "semantic-ui-react";
import { Store } from "../common/store";
import { Column, Header, IImportState, row, useImportState } from "./common";

export function makeColumns(row: row): Column[] {
  return row.map((col) => {
    return {
      pattern: col,
    };
  }) as Column[];
}

export default function ContextPage() {
  const [state, setState] = useImportState();

  const { leagueId, seasonId, divisionId } = state;
  const { leagues = [], seasons = [], divisions = [] } = state;
  const canMoveNext = !!state.seasonId && !!state.divisionId;

  const leagueOptions = leagues.map((l) => ({ text: l.name, value: l.id }));
  const seasonOptions = seasons
    .filter((s) => s.programId == leagueId)
    .map((s) => ({ text: s.name, value: s.id }));
  const divisionOptions = divisions
    .filter((d) => d.programId == leagueId)
    .map((d) => ({ text: d.name, value: d.id }));
  const BLANK = { key: "blank" };

  useEffect(() => {
    Promise.all([
      Store.leagues(),
      Store.seasons(),
      Store.divisions(),
      Store.teams(),
    ]).then((results) => {
      setState({
        leagues: results[0],
        seasons: results[1],
        divisions: results[2],
        teams: results[3],
      });
    });
  }, []);

  function patchState(patch: Partial<IImportState>) {
    setState({ ...state, ...patch });
  }

  function handleLeagueChange(_: unknown, data: SelectProps) {
    patchState({
      leagueId: data.value as number,
      seasonId: undefined,
      divisionId: undefined,
    });
  }

  function handleSeasonChange(_: unknown, data: SelectProps) {
    patchState({ seasonId: data.value as number });
  }

  function handleDivisionChange(_: unknown, data: SelectProps) {
    patchState({ divisionId: data.value as number });
  }

  return (
    <div>
      <Header
        title="Context"
        canBack={false}
        canNext={canMoveNext}
        nextUrl="/games/file"
      />
      <Form>
        <Form.Field
          control={Select}
          label="League"
          clearable
          value={leagueId}
          options={[BLANK, ...leagueOptions]}
          onChange={handleLeagueChange}
        />
        <Form.Field
          control={Select}
          label="Season"
          value={seasonId}
          options={[BLANK, ...seasonOptions]}
          onChange={handleSeasonChange}
        />
        <Form.Field
          control={Select}
          label="Division"
          value={divisionId}
          options={[BLANK, ...divisionOptions]}
          onChange={handleDivisionChange}
        />
      </Form>
    </div>
  );
}

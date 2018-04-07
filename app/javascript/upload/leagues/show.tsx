import * as React from 'react';
import { Component } from 'react';;
import { withRouter, Router } from 'react-router';
import { Store, League, Season, Division, Team } from './store';
import { asc } from '../common/utils';

interface Props {
  params: {
    programId?: string
    seasonId?: string
  },
  router: any
}

interface State {
  slug?: string;
  leagues?: League[];
  seasons?: Season[];
  divisions?: Division[];
  teams?: Team[];
}

class Show extends Component<Props,State> {

  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    Promise.all([
      Store.leagues(),
      Store.seasons(),
      Store.divisions(),
      Store.teams()
    ]).then(results => {
      this.setState({
        leagues: results[0],
        seasons: results[1],
        divisions: results[2],
        teams: results[3]
      })
    })
  }

  handleProgramChange(programId: string) {
    const { router, params } = this.props;
    const { seasonId } = this;
    router.push({
      query: {
        programId,
        seasonId
      }
    })
  }

  handleSeasonChange(seasonId: string) {
    const { router, params } = this.props;
    const { programId } = this;

    router.push(`/leagues/${programId}/seasons/${seasonId}`)
  }

  get programId(): string {
    const { leagues = [] } = this.state;
    return this.props.params.programId || (leagues[leagues.length - 1] || {})['id'];
  }

  get seasonId(): string {
    const { seasons = [] } = this.state;
    return this.props.params.seasonId || (seasons[seasons.length - 2] || {})['id'];
  }

  render() {
    const { leagues = [], seasons = [], divisions = [], teams = [] } = this.state;
    const { programId, seasonId } = this;
    return (
      <div>
        <h1 className="page-header">
          Leagues
          <div className="pull-right form-inline">
            <select
              className="form-control"
              value={programId}
              onChange={(event: any) => this.handleProgramChange(event.target.value)}
            >
              {leagues.map(league => (<option key={league.id} value={league.id}>{league.name}</option>))}
            </select>
            {" "}
            <select
              className="form-control"
              value={seasonId}
              onChange={(event: any) => this.handleSeasonChange(event.target.value)}
            >
              {seasons.map(season => (<option key={season.id} value={season.id}>{season.name}</option>))}
            </select>
          </div>
        </h1>
        <Divisions
          divisions={divisions.filter(d => d.programId == programId)}
          teams={teams.filter(t => t.seasonId == seasonId)}
        />
      </div>
    );
  }
}

function Divisions( props: { divisions: Division[], teams: Team[] }) {
  const { divisions = [], teams = [] } = props;
  return (
    <div>
      {divisions
        .sort(asc<Division>(division => division.name))
        .map(d => <DivisionPanel key={d.id} division={d} teams={teams} />)
      }
    </div>
  )
}

function DivisionPanel(props: { division: Division, teams: Team[] }) {
  const { division, teams = [] } = props;
  const styles = {
    actions: {
      marginTop: -5,
      marginRight: -10
    }
  };
  return(
    <div className="panel panel-default">
      <div className="panel-heading">
        {division.name}
        <div className="pull-right" style={styles.actions}>
          <button type="button" className="btn btn-sm btn-default">
            <i className="fa fa-gear"/>{" "}Settings
          </button>
        </div>
      </div>
      <ul className="list-group">
        {teams
          .filter(t => t.divisionId == division.id)
          .sort(asc<Team>(team => team.name))
          .map(t => (
            <TeamElement key={t.id} team={t} />
          ))
        }
      </ul>
    </div>
  )
}

export default withRouter(Show);

function TeamElement(props: { team: Team }) {
  const { team } = props;
  return (
    <li className="list-group-item">
      {team.name}
    </li>
  )
}

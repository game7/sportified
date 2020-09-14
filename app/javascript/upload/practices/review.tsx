import * as React from 'react';
import { Component } from 'react';
import * as _ from 'lodash';
import { IImportState, Header, row, storage, Map, Column, Properties } from './common';
import { Store, Team, Location, EventUpload, GameUpload } from '../common/store';
import * as moment from 'moment';
import { Button, Table, Message, Icon } from 'semantic-ui-react';

const getTeam = function(){
  let map = {};
  return (teams: Team[], id: number) : Team => {
    let team = map[id];
    if(!team) {
      team = teams.filter(t => t.id == id)[0];
      map[id] = team;
    }
    return team;
  }
}();

const getLocation = function(){
  let map = {};
  return (locations: Location[], id: number) : Location => {
    let location = map[id];
    if(!location) {
      location = locations.filter(t => t.id == id)[0];
      map[id] = location;
    }
    return location;
  }
}();

const parseDuration = (value: string) => {
  const parts = value.split(':');
  if(parts.length == 2) {
    return (parseInt(parts[0]) * 60) + parseInt(parts[1])
  }
  return value;
}

export function makeGames(state: IReviewState): GameUpload[] {
  let { rows, hasHeader, teams, locations } = state;
  if(hasHeader) [ , ...rows] = rows;

  // for each row
  const data = rows.map(row => {
    let item = {}
    // for each column
    state.columns.forEach((col, i) => {
      let key = col.property;
      switch (key) {
        case 'homeTeam':
        case 'awayTeam':
          item[key] = state.teamMaps.filter(map => map.key == row[i])[0];
          break;
        case 'location':
          item[key] = state.locationMaps.filter(map => map.key == row[i])[0];
          break;
        default:
          item[key] = row[i];
      }
    });
    return item;
  });
  // get mapped value
  const games = data.map((item: any) => {
    return {
      startsOn: item.date + ' ' + item.time,
      duration: parseDuration(item.duration),
      location: getLocation(locations, item.location.id),
      homeTeam: getTeam(teams, item.homeTeam.id),
      awayTeam: getTeam(teams, item.awayTeam.id),
      textBefore: item.textBefore,
      textAfter: item.textAfter,
      selected: true
    } as GameUpload;
  });

  return games

}

interface IReviewState extends IImportState {
  games?: GameUpload[],
  isProcessing?: boolean
}

export default class Review extends Component<{},IReviewState> {

  componentWillMount() {
    let state = storage.load() as IReviewState;
    state.games = makeGames(state)
    this.setState(state)
  }

  handleGameToggle = (id: number) => () => {
    let games = Object.assign({}, this.state.games);
    this.setState({
      games: games.map(g => {
        if(g.id == id) { g.selected = !g.selected }
        return g;
      })
    })

  }

  handleCreateGames = () => {
    this.setState({ isProcessing: true });
    const { leagueId, seasonId, divisionId } = this.state;
    let payload = {
      practice: this.state.games.map(g => {
        return {
          program_id: leagueId,
          season_id: seasonId,
          division_id: divisionId,
          starts_on: moment(new Date(g.startsOn)).format('M/D/YY h:mm a'),
          duration: g.duration,
          home_team_id: g.homeTeam.id,
          away_team_id: g.awayTeam.id,
          location_id: g.location.id,
          text_before: g.textBefore,
          text_after: g.textAfter
        }
      })
    }
    Store.createPractices(payload).then(response => {
        if(response['ok']) {
          alert('Practices have been posted');
        } else {
          alert('Oops!  Something didn\'t go right...');
          this.setState({ isProcessing: false });
        }
    })
  }  

  render() {
    const { isProcessing } = this.state;
    console.log(this.state)
    return (
      <div>
        <Header
          title="Review"
          canBack={true}
          backUrl="/practices/mapping"
          canNext={false}
        />
        <Message info icon="info circle" header="You're almost there!" content="Scroll to buttom to Submit" />
        <Table celled striped>
          <Table.Header>
            <Table.Row>
              <Table.HeaderCell>Date / Time</Table.HeaderCell>
              <Table.HeaderCell>Duration</Table.HeaderCell>
              <Table.HeaderCell>Location</Table.HeaderCell>
              {/* <Table.HeaderCell>Summary</Table.HeaderCell> */}
              <Table.HeaderCell>Home</Table.HeaderCell>
              <Table.HeaderCell>Away</Table.HeaderCell>
              <Table.HeaderCell>Text Before</Table.HeaderCell>
              <Table.HeaderCell>Text After</Table.HeaderCell>
              {/* <Table.HeaderCell>Tags</Table.HeaderCell> */}
            </Table.Row>
          </Table.Header>
          <Table.Body>
            {this.state.games.map((g, i)=> (
              <Table.Row key={i}>
                {/* {/*
                <Table.Cell style={{textAlign: 'center'}}>
                  <input type="checkbox" checked={g.selected} onChange={this.handleGameToggle(g.id)}/>
                </Table.Cell>
                */}
                <Table.Cell>{moment(new Date(g['startsOn'])).format('ddd M/D/YY h:mma').replace('m','')}</Table.Cell>
                <Table.Cell>{g['duration']}</Table.Cell>
                <Table.Cell>{g['location']['name']}</Table.Cell>
                {/* <Table.Cell>{g['summary']}</Table.Cell> */}
                <Table.Cell>{g['homeTeam']['name']}</Table.Cell>
                <Table.Cell>{g['awayTeam']['name']}</Table.Cell>
                <Table.Cell>{g['textBefore']}</Table.Cell>
                <Table.Cell>{g['textAfter']}</Table.Cell>
                {/* <Table.Cell>{g['tags']}</Table.Cell> */}
              </Table.Row>
            ))}
          </Table.Body>
        </Table>
        <Button primary onClick={this.handleCreateGames} content="Create" disabled={isProcessing} />
        <p style={{height: 20}}> </p>
      </div>
    );
  }
}

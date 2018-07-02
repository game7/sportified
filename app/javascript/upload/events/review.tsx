import * as React from 'react';
import { Component } from 'react';
import * as _ from 'lodash';
import { IImportState, Header, row, storage, Map, Column, Properties } from './common';
import { Store, Team, Location, EventUpload } from '../common/store';
import * as moment from 'moment';

const getTeam = function(){
  let map = {};
  return (teams: Team[], id: string) : Team => {
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
  return (locations: Location[], id: string) : Location => {
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

const mergeTags = (existing: string, next:string) => {
  if(!existing) return next;
  if(!next) return existing;
  const tags = existing.split(',');
  return [...tags, next].join(',')
}

export function makeEvents(state: IReviewState): EventUpload[] {
  let { rows, hasHeader, locations } = state;
  if(hasHeader) [ , ...rows] = rows;
  console.log(state.locationMaps)
  // for each row
  const data = rows.map(row => {
    let item = {}
    // for each column
    state.columns.forEach((col, i) => {
      let key = col.property;
      switch (key) {
        case 'duration':
          item[key] = parseDuration(row[i])
          break;
        case 'location':
          item[key] = state.locationMaps.filter(map => map.key == row[i])[0];
          break;
        case 'prependTags':
          item['tags'] = mergeTags(row[i], item['tags'])
          break;
        case 'appendTags':
          item['tags'] = mergeTags(item['tags'], row[i])
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
      summary: item.summary,
      startsOn: item.date + ' ' + item.time,
      duration: item.duration,
      location: item.location ? getLocation(locations, item.location.id) : {},
      homeTeam: item.homeTeam,
      awayTeam: item.awayTeam,
      tags: item.tags,
      selected: true
    } as EventUpload;
  });

  return games

}

interface IReviewState extends IImportState {
  games?: EventUpload[],
  isProcessing?: boolean
}

export default class Review extends Component<{},IReviewState> {

  componentWillMount() {
    let state = storage.load() as IReviewState;
    state.games = makeEvents(state)
    this.setState(state)
  }

  handleGameToggle = (id: string) => () => {
    let games = Object.assign({}, this.state.games);
    this.setState({
      games: games.map(g => {
        if(g.id == id) { g.selected = !g.selected }
        return g;
      })
    })

  }

  handleCreateEvents = () => {
    this.setState({ isProcessing: true });
    const { leagueId, seasonId, divisionId } = this.state;
    let payload = {
      event: this.state.games.map(g => {
        const all_day_duration = (24 * 60);
        const duration = g.duration || all_day_duration;
        return {
          starts_on: moment(new Date(g.startsOn)).format('M/D/YY h:mm a'),
          duration: duration,
          summary: g.summary,
          home_team_custom_name: g.homeTeam,
          away_team_custom_name: g.awayTeam,
          location_id: g.location.id,
          tag_list: g.tags,
          all_day: (duration == all_day_duration)
        }
      })
    }
    Store.createEvents(payload).then(response => {
        if(response['ok']) {
          alert('Games have been posted');
        } else {
          alert('Oops!  Something didn\'t go right...');
          this.setState({ isProcessing: false });
        }
    })
  }

  render() {
    let buttonCss = ['btn', 'btn-primary'];
    if(this.state.isProcessing) {
      buttonCss.push('disabled');
    }
    return (
      <div>
        <Header
          title="Review"
          canBack={true}
          backUrl="/events/mapping"
          canNext={false}
        />
        <p>
          <em>Scroll to bottom to Submit</em>
        </p>
        <table className="table table-bordered table-striped">
          <thead>
            <tr>
              <th>Date / Time</th>
              <th>Duration</th>
              <th>Location</th>
              <th>Summary</th>
              <th>Home</th>
              <th>Away</th>
              <th>Tags</th>
            </tr>
          </thead>
          <tbody>
            {this.state.games.map((g, i)=> (
              <tr key={i}>
                {/*
                <td style={{textAlign: 'center'}}>
                  <input type="checkbox" checked={g.selected} onChange={this.handleGameToggle(g.id)}/>
                </td>
                */}
                <td>{moment(new Date(g['startsOn'])).format('ddd M/D/YY h:mma').replace('m','')}</td>
                <td>{g['duration']}</td>
                <td>{g['location']['name']}</td>
                <td>{g['summary']}</td>
                <td>{g['homeTeam']}</td>
                <td>{g['awayTeam']}</td>
                <td>{g['tags']}</td>
              </tr>
            ))}
          </tbody>
        </table>
        <button className={buttonCss.join(' ')} onClick={this.handleCreateEvents}>Create Events</button>
        <p style={{height: 20}}> </p>
      </div>
    );
  }
}

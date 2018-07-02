import * as React from 'react';

export interface Tenant {
  id: string;
  name: string;
  url: string;
}

export interface League {
  id: string;
  name: string;
  description: string;
  created_at: string;
  updated_at: string;
}

export interface Season {
  id: string;
  programId: string;
  name: string;
  description: string;
  createdAt: string;
  updatedAt: string;
}

export interface Division {
  id: string;
  programId: string;
  name: string;
  description: string;
  createdAt: string;
  updatedAt: string;
}

export interface Team {
  id: string
  seasonId: string
  divisionId: string
  name: string
  shortName: string
}

export interface Location {
  id: string
  name: string
  shortName: string
}

export interface GameUpload {
  id: string;
  startsOn: string;
  duration: string;
  homeTeam: Team;
  awayTeam: Team;
  location: Location;
  selected: boolean;
  processing: boolean;
  completed: boolean;
}

export interface EventUpload {
  id?: string;
  summary?: string;
  startsOn: string;
  duration: string;
  homeTeam: string;
  awayTeam: string;
  location: Location;
  tags: string;
  selected: boolean;
  processing: boolean;
  completed: boolean;
}


export interface PlayerUpload {
  firstName: string;
  lastName: string;
  team: Team;
  jerseyNumber: string;
  email: string;
  birthdate: string;
  substitute: boolean;
  position: string;
}

function get(path) {
  const url = process.env.API_BASE + path;
  const options = {
    headers: {},
    credentials: 'include'
  } as RequestInit;
  console.log(options)
  return fetch(url, options)
}

export class Store {

  static tenants() {
    return get('api/league/tenants')
      .then<Tenant[]>(response => response.json());
  }

  static leagues() {
    return get('api/league/programs')
      .then<League[]>(response => response.json());
  }

  static seasons() {
    return get('api/league/seasons')
      .then<Season[]>(response => response.json());
  }

  static divisions() {
    return get('api/league/divisions')
      .then<Division[]>(response => response.json());
  }

  static teams() {
    return get('api/league/teams')
      .then<Team[]>(response => response.json());
  }

  static locations() {
    return get('api/locations')
      .then<Location[]>(response => response.json());
  }

  static createGames(games: any) {
    return fetch(process.env.API_BASE + 'api/league/games/batch_create', {
      method: 'POST',
      body: JSON.stringify(games),
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json'
      }
    })
  }

  static createEvents(events: any) {
    return fetch(process.env.API_BASE + 'api/general/events/batch_create', {
      method: 'POST',
      body: JSON.stringify(events),
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json'
      }
    })
  }

  static createPlayers(players: any) {
    return fetch(process.env.API_BASE + 'api/league/players/batch_create', {
      method: 'POST',
      body: JSON.stringify(players),
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json'
      }
    })
  }

}

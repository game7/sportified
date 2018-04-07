import * as React from 'react';

export interface Model {
  id: string;
}

export interface Tenant extends Model {
  name: string;
  url: string;
}

export interface League extends Model {
  name: string;
  description: string;
  created_at: string;
  updated_at: string;
}

export interface Season extends Model {
  programId: string;
  name: string;
  description: string;
  createdAt: string;
  updatedAt: string;
}

export interface Division extends Model {
  programId: string;
  name: string;
  description: string;
  createdAt: string;
  updatedAt: string;
}

export interface Team extends Model {
  seasonId: string
  divisionId: string
  name: string
  shortName: string
}

export interface Location extends Model {
  name: string
  shortName: string
}

export interface GameUpload extends Model {
  startsOn: string;
  duration: string;
  homeTeam: Team;
  awayTeam: Team;
  location: Location;
  selected: boolean;
  processing: boolean;
  completed: boolean;
}

const unwrap = (response: Response) => response.json();

export class ResourceConfig {

}

export class Resource<T extends Model> {

  private loaded: boolean = false;
  private list: T[] = [];
  private hash: { [id: string] : T} = {};

  constructor() {

  }

  load(): Promise<boolean> {
    return fetch(process.env.API_BASE + '/api/league/tenants')
      .then(unwrap)
      .then(json => {
        const models = json['tenants'] as T[];
        this.list = models;
        this.hash = models.reduce((map, obj) => {
          map[obj.id] = obj;
          return map;
        }, {});
        this.loaded = true;
        return true;
      })
  }

  all(): Promise<T[]> {
    if(this.loaded) Promise.resolve(this.list);
    return this.load().then(() => this.list)
  }

  private push(model: T) {
    this.list = [
      ...this.list,
      model
    ];
    this.hash = {
      ...this.hash,
      [model.id]: model
    };
  }

  private patch(model: T) {
    this.list = this.list.map(obj => obj.id == model.id ? model : obj)
    this.hash = {...this.hash, [model.id]: model};
  }

  private remove(id: string) {

  }

  get(id: number): Promise<T> {
    if(this.hash[id]) Promise.resolve(this.hash[id]);
    return fetch(process.env.API_BASE + `/api/league/tenants/${id}`)
      .then(unwrap)
      .then(json => {
        const model = json['tenants'] as T;
        this.push(model);
        return model;
      });
  }

  create(data: any): Promise<T> {
    const opt = {
      method: 'POST'
    }
    return fetch(process.env.API_BASE + `/api/league/tenants`, opt)
      .then(unwrap)
      .then(json => {
        const model = json['tenants'] as T;
        this.push(model);
        return model;
      });
  }

  // update(data: any): Promise<T> {
  //   const opt = {
  //     method: 'PATCH'
  //   }
  //   return fetch(process.env.API_BASE + `/api/league/tenants/${id}`, opt)
  //     .then(unwrap)
  //     .then(json => json);
  // }

  delete(id: number): Promise<boolean> {
    const opt = {
      method: 'DELETE'
    }
    return fetch(process.env.API_BASE + `/api/league/tenants/${id}`, opt)
      .then(unwrap)
      .then(() => true);
  }

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
    return get('/api/league/tenants')
      .then(unwrap)
      .then(data => data['tenants'] as Tenant[]);
  }

  static leagues(): Promise<League[]> {
    return get('/api/league/programs')
      .then(unwrap)
      .then(data => data['leagues'] as Promise<League[]>);
  }

  static seasons() {
    return get('/api/league/seasons')
      .then(unwrap)
      .then(data => data['seasons'] as Season[]);
  }

  static divisions() {
    return get('/api/league/divisions')
      .then(unwrap)
      .then(data => data['divisions'] as Division[]);
  }

  static teams() {
    return get('/api/league/teams')
      .then(unwrap)
      .then(data => data['teams'] as Team[]);
  }

  static locations() {
    return get('/api/locations')
      .then(unwrap)
      .then(data => data['locations'] as Location[]);
  }

  static createGames(games: any) {
    return fetch(process.env.API_BASE + '/api/league/games/batch_create', {
      method: 'POST',
      body: JSON.stringify(games),
      headers: {
        'Content-Type': 'application/json'
      },
      credentials: 'same-origin'
    })
  }

}

import { inject }           from 'aurelia-framework';
import { HttpClient, json } from 'aurelia-fetch-client';
import { Configuration }    from './configuration';
import JsonApi              from 'devour-client';
import _                    from 'lodash';

function camelize(item) {
  return _.mapKeys(item, (value, key) => {
    return _.camelCase(key);
  })
}

let camelizeMiddleware = {
  name: 'camelize',
  res: (payload) => {
    if(payload.map) {
      return payload.map((item) => {
        return camelize(item);
      });
    } else {
      return camelize(item);
    }
  }
}

export function parameterize(params) {
  let results = [];
  for(let key in params) {
    results.push(`${key}=${params[key]}`);
  }
  return results.join('&');
}

@inject(HttpClient, Configuration)
export class Store {

  constructor(http, configuration) {
    
    this.api = new JsonApi({
      apiUrl: configuration.api.baseUrl
    });
    this.api.insertMiddlewareAfter('response', camelizeMiddleware);
    this.http = http.configure(config => {
      config
        .useStandardConfiguration()
        .withBaseUrl(configuration.api.baseUrl);
    });

    let event = {
      summary: '',
      description: '',
      starts_on: '',
      ends_on: '',
      program_id: '',
      program: {
        jsonApi: 'belongsTo',
        type: 'program'
      }

    };
    this.api.define('event', event);
    this.api.define('league_game', event);
    this.api.define('league_event', event);
    this.api.define('activity_session', event);
    let program = {
      name: '',
    };
    this.api.define('activity_program', program);
    this.api.define('league_program', program);

  }

  static get current() {
    if (!Store._current) {
      Store._current = new Store(new HttpClient(), new Configuration());
    }
    return Store._current;
  }

  inflect(type) {
    if(type.toLowerCase) {
      return type.toLowerCase() + 's';
    }
    return type.plural || type.name.toLowerCase() + 's';
  }

  all(type, params = {}) {
    // let base = this.inflect(type);
    // let query = parameterize(params || {});
    // let url = `${base}${query.length > 0 ? '?' : ''}${query}`;
    // return this.http.fetch(url).then(response => response.json()).then((json) => {
    //   return json.data;
    // })
    
    return this.api.all(type).get(params)
  }

}

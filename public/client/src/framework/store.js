import { inject }           from 'aurelia-framework';
import { HttpClient, json } from 'aurelia-fetch-client';

export function parameterize(params) {
  let results = [];
  for(let key in params) {
    results.push(`${key}=${params[key]}`);
  }
  return results.join('&');
}

@inject(HttpClient)
export class Store {

  constructor(http) {
    this.http = http.configure(config => {
      config
        .useStandardConfiguration()
        .withBaseUrl('api/')
    });
  }

  static get current() {
    if (!Store._current) {
      Store._current = new Store(new HttpClient());
    }
    return Store._current;
  }

  inflect(type) {
    if(type.toLowerCase) {
      return type.toLowerCase() + 's';
    }
    return type.plural || type.name.toLowerCase() + 's';
  }

  all(type, params) {
    let base = this.inflect(type);
    let query = parameterize(params || {});
    return this.http.fetch(this.inflect(type)).then(response => response.json()).then((json) => {
      return json.data;
    })
  }

}

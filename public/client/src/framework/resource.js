import { inject } from 'aurelia-framework';
import { Store }  from './store';

export class Resource {

  constructor(data) {
    this.id = data['id'];
    let attributes = data['attributes'] || [];
    for(let key in attributes) {
      this[key] = attributes[key];
    }
  }

  static all(type, params) {
    return Store.current.all(type, params).then((results) => {
      return results.map((result) => {
        return new Resource(result);
      })
    })
  }

}

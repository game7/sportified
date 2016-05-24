import { inject } from 'aurelia-framework';
import { Resource }  from 'framework/resource';

export class Index {

  constructor() {

  }

  activate(params) {
    let days = params['days'] || 7;
    return this.fetch(days)
  }

  fetch(daysInThePast) {
    return Resource.all('game', { days: daysInThePast }).then((games) => {
      this.games = games;
    })
  }

}

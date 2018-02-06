import * as moment from 'moment';

export interface Event {
  startsOn: Date;
  endsOn: Date;
  Summary: string;
}

export class Store {

  static getEvents(date: Date): Promise<Event[]> {

    const from = moment(date).format("YYYY-MM-01");
    const to = moment(date).format("YYYY-MM-") + moment(date).daysInMonth();
    const headers = new Headers();
    headers.append("Accept", "application/json");
    headers.append("Content-Type", "application/json");
    return fetch(`/api/events?from=${from}&to=${to}`, {
      credentials: 'same-origin',
      headers: headers
    }).then(response => response.json())
      .then(json => json['events'])
      .then(data => data.map(event => {
        return {
          ...event,
          startsOn: new Date(event.startsOn),
          endsOn: new Date(event.endsOn)
        } as Event
      }))

  }

}

export default Store;

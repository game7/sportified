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

    return fetch(`/api/events?from=${from}&to=${to}`)
      .then(response => response.json())
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

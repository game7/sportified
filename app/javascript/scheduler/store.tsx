import moment from 'moment';

export interface Event {
  id: string;
  startsOn: Date;
  endsOn: Date;
  duration: number;
  summary: string;
  tags: string[]
}

export interface Tag {
  id: string;
  name: string;
  color: string;
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
      .then(data => data.map(event => {
        return {
          ...event,
          startsOn: new Date(event.startsOn),
          endsOn: new Date(event.endsOn)
        } as Event
      }))

  }

  static getTags(): Promise<Tag[]> {

    const headers = new Headers();
    headers.append("Accept", "application/json");
    headers.append("Content-Type", "application/json");

    return fetch(`/api/tags`, {
      credentials: 'same-origin',
      headers: headers
    }).then<Tag[]>(response => response.json())

  }

}

export default Store;


import {
  Item
} from '../data';

class Repository {


}

class Resource<T> {

  private map: { [id: string]: T };
  private model: string;
  private endpoint: string;

  constructor(endpoint: string) {
    this.endpoint = endpoint;
  }

  private flatten(data: any) {
    const { id, attributes } = data;
    return {
      ...attributes,
      id
    } as T
  }

  list() {
    return fetch(this.endpoint)
      .then(response => response.json())
      .then()
  }

  get(id: number): Promise<T> {
    const obj = this.map[id];
    if (obj) return Promise.resolve(obj);
    return fetch(`${this.endpoint}/${id}`)
      .then(response => response.json())
      .then(data => this.flatten(data))
  }

  update(id: number, attributes: Partial<T>) {

  }

  create(attributes: Partial<T>) {

  }

  delete(id: number) {

  }
}


export class Store {


}

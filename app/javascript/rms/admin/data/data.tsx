

export interface Identity<T> {
  id: number;
  type: string;
}

export interface Relationship<T> {
  data: Identity<T>;
}

export interface Model<T,A,R> extends Identity<T> {
  attributes: A;
  relationships: R
}

interface Collection {
  [id: number]: any;
}

interface Storage {
  [type: string]: Collection;
}

export class Store {

  private storage: Storage;

  constructor() {
    this.storage = {} as Storage;
  }

  private ensure(type: string) {
    this.storage[type] = this.storage[type] || {};
  }

  get(type: string, id: number) {
    this.ensure(type);
    return this.storage[type][id];
  }

  set(type: string, id: number, data: any) {
    this.ensure(type);
    this.storage[type][id] = data;
  }

}

export class Repository<T,A> {

  constructor(
    private store: Store,
    private type: string,
    private endpoint: string
  ) { }

  get(id: number) {
    const data = this.store.get(this.type, id) as T;
    if(data) return Promise.resolve(data);
    fetch(`${this.endpoint}/${id}`)
      .then(response => response.json())
      .then(json => {
        debugger;
      })
  }

  update(id: number, attrs: Partial<A>) {
    // const current = this.store.get(this.type, id);
    // const updated = { ...current, ...attrs };
    // this.store.set(this.type, id, updated);
  }

}

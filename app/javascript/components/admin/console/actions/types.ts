
export interface Action<T> {
  type: string
  payload: T
}

export type ActionHandler<Payload, Response> = (payload: Payload) => Promise<Response>

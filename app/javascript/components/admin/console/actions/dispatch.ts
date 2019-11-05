import { Action } from './types';

export async function dispatch<T, R>(action: Action<T>): Promise<R> {
  const headers = new Headers();
  headers.append("Accept", "application/json");
  headers.append("Content-Type", "application/json");

  const response = await fetch(`/actions/${action.type}`, {
    method: 'POST',
    credentials: 'same-origin',
    headers: headers,
    body: JSON.stringify(action)
  })
  const json = await response.json()
  if(response.ok) { return json }
  throw json;
}

export default dispatch;

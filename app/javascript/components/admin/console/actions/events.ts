import { ActionHandler } from './types';
import dispatch from './dispatch';

export interface Event {
  description: string
  duration: number
  endsOn: string
  id: number
  location: Location
  locationId: number
  // program: null
  programId: number
  startsOn: string
  summary: string
  tags: number[]
}

export const list: ActionHandler<{ date: Date }, Event[]> = (payload) => {
  return dispatch<{}, Event[]>({
    type: 'events/list',
    payload
  }).then(res => res['events'])
}


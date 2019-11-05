import { ActionHandler } from './types';
import dispatch from './dispatch';

export interface Game {
  id: number
  startsOn: Date
  summary: string
}

export const list: ActionHandler<{}, Game[]> = (payload) => {
  return dispatch<{}, Game[]>({
    type: 'games/list',
    payload
  }).then(res => res['games'])
}


import { ActionHandler } from './types';
import dispatch from './dispatch';

export interface Tag {
    id: string;
    name: string;
    color: string;
  }

export const list: ActionHandler<{}, Tag[]> = (payload) => {
  return dispatch<{}, Tag[]>({
    type: 'tags/list',
    payload
  }).then(res => res['actsAsTaggableOn::Tags'])
}


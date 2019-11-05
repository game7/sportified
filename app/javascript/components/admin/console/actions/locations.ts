import { ActionHandler } from './types';
import dispatch from './dispatch';

export interface Location {
  id: number
  name: string
  shortName: string
}

export const find: ActionHandler<{ id: number }, Location> = (payload) => {
  return dispatch<{}, Location>({
    type: 'locations/find',
    payload
  }).then(res => res['location'])
}

export const list: ActionHandler<{}, Location[]> = (payload) => {
  return dispatch<{}, Location[]>({
    type: 'locations/list',
    payload
  }).then(res => res['locations'])
}

export interface CreateLocationPayload {
  attributes: Partial<{
    name: string
    shortName: string
  }>
}

export const create: ActionHandler<Partial<CreateLocationPayload>, Location> = (payload) => {
  return dispatch<Partial<CreateLocationPayload>, Location>({
    type: 'locations/create',
    payload
  })
}

export interface UpdateLocationPayload {
  id: number
  attributes: Partial<{
    name: string
    shortName: string
  }>
}

export const update: ActionHandler<UpdateLocationPayload, Location> = (payload) => {
  return dispatch<UpdateLocationPayload, Location>({
    type: 'locations/update',
    payload
  })
}

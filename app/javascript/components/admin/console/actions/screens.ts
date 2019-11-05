import { ActionHandler } from './types';
import dispatch from './dispatch';
import { Location } from './locations';

export interface Screen {
  createdAt: string
  id: number
  locationId: number
  location?: Location
  name: "Locker Rooms 2"
  refreshedAt: string
  updatedAt: string
}

export const find: ActionHandler<{ id: number }, Screen> = (payload) => {
  return dispatch<{}, Screen>({
    type: 'screens/find',
    payload
  }).then(res => res['chromecast'])
}

export const list: ActionHandler<{}, Screen[]> = (payload) => {
  return dispatch<{}, Screen[]>({
    type: 'screens/list',
    payload
  }).then(res => res['chromecasts'])
}

export interface CreateScreenPayload {
  attributes: Partial<{
    name: string,
    locationId: number
  }>
}

export const create: ActionHandler<Partial<CreateScreenPayload>, Screen> = (payload) => {
  return dispatch<Partial<CreateScreenPayload>, Screen>({
    type: 'screens/create',
    payload
  })
}

export interface UpdateScreenPayload {
  id: number
  attributes: Partial<{
    name: string,
    locationId: number
  }>
}

export const update: ActionHandler<UpdateScreenPayload, Screen> = (payload) => {
  return dispatch<UpdateScreenPayload, Screen>({
    type: 'screens/update',
    payload
  })
}

export const destroy: ActionHandler<{ id: number }, Screen> = (payload) => {
  return dispatch<{}, Screen>({
    type: 'screens/delete',
    payload
  }).then(res => res['chromecast'])
}

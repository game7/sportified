import { ActionHandler } from './types';
import dispatch from './dispatch';
// import { Season } from './seasons';
// import { Division } from './divisions';

export interface Player {
  birthdate: string
  createdAt: string
  email: string
  firstName: string
  id: number
  jerseyNumber: string
  lastName: string
  position: string
  slug: string
  substitute: boolean
  teamId: number
  tenantId: number
  updatedAt: string
}

type Association = "seasons" | "divisions" | "players"

interface FindPlayerParams {
  id: number
  include?: Association[]
}

export const find: ActionHandler<FindPlayerParams, Player> = (payload) => {
  return dispatch<FindPlayerParams, Player>({
    type: 'players/find',
    payload
  }).then(res => res['player'])
}

interface ListOptions {
  seasonId?: number
}

export const list: ActionHandler<ListOptions, Player[]> = (payload) => {
  return dispatch<ListOptions, Player[]>({
    type: 'players/list',
    payload
  }).then(res => res['players'])
}

export interface CreatePlayerPayload {
  attributes: Partial<{
    name: string
    description: string
  }>
}

export const create: ActionHandler<Partial<CreatePlayerPayload>, Player> = (payload) => {
  return dispatch<Partial<CreatePlayerPayload>, Player>({
    type: 'players/create',
    payload
  })
}

export interface UpdatePlayerPayload {
  id: number
  attributes: Partial<{
    name: string
    description: string
  }>
}

export const update: ActionHandler<UpdatePlayerPayload, Player> = (payload) => {
  return dispatch<UpdatePlayerPayload, Player>({
    type: 'players/update',
    payload
  })
}

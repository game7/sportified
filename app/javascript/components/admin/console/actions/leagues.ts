import { ActionHandler } from './types';
import dispatch from './dispatch';
import { Season } from './seasons';
import { Division } from './divisions';
import { Team } from './teams';

export interface League {
  createdAt: string
  description: string
  id: number
  name: string
  updatedAt: string,
  divisions?: Division[]
  seasons?: Season[]
}

type Association = "seasons" | "divisions" | "teams"

interface FindLeagueParams {
  id: number
  include?: Association[]
}

export const find: ActionHandler<FindLeagueParams, League> = (payload) => {
  return dispatch<FindLeagueParams, League>({
    type: 'leagues/find',
    payload
  }).then(res => res['league'])
}

export const list: ActionHandler<{}, League[]> = (payload) => {
  return dispatch<{}, League[]>({
    type: 'leagues/list',
    payload
  }).then(res => res['leagues'])
}

export interface CreateLeaguePayload {
  attributes: Partial<{
    name: string
    description: string
  }>
}

export const create: ActionHandler<Partial<CreateLeaguePayload>, League> = (payload) => {
  return dispatch<Partial<CreateLeaguePayload>, League>({
    type: 'leagues/create',
    payload
  })
}

export interface UpdateLeaguePayload {
  id: number
  attributes: Partial<{
    name: string
    description: string
  }>
}

export const update: ActionHandler<UpdateLeaguePayload, League> = (payload) => {
  return dispatch<UpdateLeaguePayload, League>({
    type: 'leagues/update',
    payload
  })
}

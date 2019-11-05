import { ActionHandler } from './types';
import dispatch from './dispatch';

export interface Division {
  createdAt: string
  id: number
  name: string
  periodLength: number
  programId: number
  showPlayers: boolean
  showStandings: boolean
  showStatistics: boolean
  slug: string
  standingsArray: string[]
  standingsSchemaId: string
  tenantId: number
  updatedAt: string
  seasonIds: number[]
}

type Associations = 'divisions' | 'seasons'

export const find: ActionHandler<{ id: number, include?: Associations[] }, Division> = (payload) => {
  return dispatch<{}, Division>({
    type: 'divisions/find',
    payload
  }).then(res => res['division'])
}

interface ListDivisionsArgs {
  leagueId: number
}

export const list: ActionHandler<ListDivisionsArgs, Division[]> = (payload) => {
  return dispatch<ListDivisionsArgs, Division[]>({
    type: 'divisions/list',
    payload
  }).then(res => res['divisions'])
}

export interface CreateDivisionPayload {
  attributes: Partial<{
    name: string
    description: string
  }>
}

export const create: ActionHandler<Partial<CreateDivisionPayload>, Division> = (payload) => {
  return dispatch<Partial<CreateDivisionPayload>, Division>({
    type: 'divisions/create',
    payload
  })
}

export interface UpdateDivisionPayload {
  id: number
  attributes: Partial<{
    name: string
    description: string
  }>
}

export const update: ActionHandler<UpdateDivisionPayload, Division> = (payload) => {
  return dispatch<UpdateDivisionPayload, Division>({
    type: 'divisions/update',
    payload
  })
}

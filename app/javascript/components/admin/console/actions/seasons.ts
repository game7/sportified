import { ActionHandler } from './types';
import dispatch from './dispatch';

export interface Season {
  createdAt: string
  id: number
  name: string
  programId: number
  slug: string
  startsOn: string
  tenantId: number
  updatedAt: string
  divisionIds: number[]
}

type Associations = 'seasons' | 'seasons'

export const find: ActionHandler<{ id: number, include?: Associations[] }, Season> = async (payload) => {
  return dispatch<{}, Season>({
    type: 'seasons/find',
    payload
  }).then(res => res['season'])
}

export const list: ActionHandler<{}, Season[]> = async (payload) => {
  return dispatch<{}, Season[]>({
    type: 'seasons/list',
    payload
  }).then(res => res['seasons'])
}

export interface CreateSeasonPayload {
  attributes: Partial<{
    name: string
    description: string
  }>
}

export const create: ActionHandler<Partial<CreateSeasonPayload>, Season> = (payload) => {
  return dispatch<Partial<CreateSeasonPayload>, Season>({
    type: 'seasons/create',
    payload
  })
}

export interface UpdateSeasonPayload {
  id: number
  attributes: Partial<{
    name: string
    description: string
  }>
}

export const update: ActionHandler<UpdateSeasonPayload, Season> = (payload) => {
  return dispatch<UpdateSeasonPayload, Season>({
    type: 'seasons/update',
    payload
  })
}

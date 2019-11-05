import { ActionHandler } from './types';
import dispatch from './dispatch';
import { Season } from './seasons';
import { Division } from './divisions';
import { Player } from './players';

export interface Team {
  accentColor: string
  allowed: number
  avatarUrl: string
  avatar: {
    data: string
  }
  clubId: number
  createdAt: string
  cropH: number
  cropW: number
  cropX: number
  cropY: number
  currentRun: number
  customColors: string
  divisionId: number
  forfeitLosses: number
  forfeitWins: number
  gamesPlayed: number
  id: number
  lastResult: string
  logo: {
    url: string,
    small: {
      url: string
    },
    thumb: {
      url: string
    },
    tiny: {
      url: string
    },
    micro: {
      url: string
    }
  }
  url: string
  longestLossStreak: number
  longestWinStreak: number
  losses: number
  mainColors: any
  margin: number
  name: string
  overtimeLosses: number
  overtimeWins: number
  percent: number
  points: number
  pool: ""
  primaryColor: string
  scored: number
  seasonId: number
  secondaryColor: string
  seed: string
  shootoutLosses: number
  shootoutWins: number
  shortName: string
  showInStandings: boolean
  slug: string
  tenantId: number
  ties: number
  updatedAt: string
  wins: number
  players?: Player[]
}

type Association = "seasons" | "divisions" | "teams"

interface FindTeamParams {
  id: number
  include?: Association[]
}

export const find: ActionHandler<FindTeamParams, Team> = (payload) => {
  return dispatch<FindTeamParams, Team>({
    type: 'teams/find',
    payload
  }).then(res => res['team'])
}

interface ListTeamsOptions {
  seasonId?: number
}

export const list: ActionHandler<ListTeamsOptions, Team[]> = (payload) => {
  return dispatch<ListTeamsOptions, Team[]>({
    type: 'teams/list',
    payload
  }).then(res => res['teams'])
}

export interface CreateTeamPayload {
  attributes: Partial<{
    name: string
    description: string
  }>
}

export const create: ActionHandler<Partial<CreateTeamPayload>, Team> = (payload) => {
  return dispatch<Partial<CreateTeamPayload>, Team>({
    type: 'teams/create',
    payload
  })
}

export interface UpdateTeamPayload {
  id: number
  attributes: Partial<{
    name: string
    description: string
  }>
}

export const update: ActionHandler<UpdateTeamPayload, Team> = (payload) => {
  return dispatch<UpdateTeamPayload, Team>({
    type: 'teams/update',
    payload
  })
}

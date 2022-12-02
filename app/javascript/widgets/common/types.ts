
export interface Season {
  id: number;
  programId: number;
  name: string;
  slug: string;
  startsOn: string;
  createdAt: string;
  updatedAt: string;
}

export interface Division {
  id: number;
  programId: number;
  name: string;
  slug: string;
  showStandings: boolean;
  showPlayers: boolean;
  showStatistics: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface Club {
  id: number;
  name: string;
  short_name: string;
  tenant_id: number;
  created_at: string;
  updated_at: string; 
}

export interface Team {
  id: number;
  name: string;
  shortName: string;
  slug: string;
  showInStandings: true,
  pool: string;
  seed: number;
  tenantId: number;
  divisionId: number | string;
  seasonId: number | string;
  clubId: number | string;
  logo: {
    url: string;
    small: string;
    thumb: string;
    tiny: string;
    micro: string;
  };
  primaryColor: string;
  secondaryColor: string;
  accentColor: string;
  mainColors: string[];
  customColors: string[];
  cropX: number;
  cropY: number;
  cropH: number;
  cropW: number;
  createdAt: string;
  updatedAt: string;
  gamesPlayed: number;
  wins: number;
  losses: number;
  ties: number;
  overtimeWins: number;
  overtimeLosses: number;
  shootoutWins: number;
  shootoutLosses: number;
  forfeitWins: number;
  forfeitLosses: number;
  points: number;
  percent: number;
  scored: number;
  allowed: number;
  margin: number;
  lastResult: string;
  currentRun: number;
  longestWinStreak: number;
  longestLossStreak: number; 
  url: string;
}

export interface Player {
  id: number;
  tenantId: number;
  teamId: number;
  firstName: string;
  lastName: string;
  jerseyNumber: string;
  birthdate: string;
  email: string;
  slug: string;
  createdAt: string;
  updatedAt: string;
  substitute: boolean;
  position: string;
}

export interface Skater {
  id: number;
  type: string;
  tenantId: number;
  teamId: number;
  playerId: number;
  statsheetId: number;
  jerseyNumber: string;
  gamesPlayed: number;
  goals: number;
  assists: number;
  points: number;
  penalties: number;
  penaltyMinutes: number;
  minorPenalties: number;
  majorPenalties: number;
  misconductPenalties: number;
  gameMisconductPenalties: number;
  hatTricks: number;
  playmakers: number;
  gordieHowes: number;
  ejections: number;
  createdAt: string;
  updatedAt: string;
  firstName: string;
  lastName: string;  
}

export interface Goal {
  id: number;
  tenantId: number;
  statsheetId: number;
  period: number;
  minute: number | string;
  second: number | string;
  teamId: number;
  scoredById: number;
  scoredOnId: number;
  assistedById: number;
  alsoAssistedById: number;
  strength: string;
  createdAt: string;
  updatedAt: string;
  scoredByNumber: number;
  assistedByNumber: number;
  alsoAssistedByNumber: number;
}

export interface Game {
  id: number;
  tenantId: number;
  divisionId: number;
  seasonId: number;
  locationId: number;
  type: string;
  startsOn: string;
  endsOn: string;
  duration: number;
  allDay: boolean;
  summary: string;
  description: null,
  createdAt: string;
  updatedAt: string;
  homeTeamId: number;
  awayTeamId: number;
  statsheetId: number;
  statsheetType: string;
  homeTeamScore: number;
  awayTeamScore: number;
  homeTeamName: string;
  awayTeamName: string;
  homeTeamCustomName: null,
  awayTeamCustomName: null,
  textBefore: null,
  textAfter: null,
  result: string;
  completion: string;
  excludeFromTeamRecords: boolean;
  playingSurfaceId: number;
  homeTeamLockerRoomId: number;
  awayTeamLockerRoomId: number;
  programId: number;
  pageId: number;
  private: boolean;
  tagList: string;
}

export interface Settings {
  id: number;
  tenantId: number;
  posted: boolean;
  awayScore: number;
  homeScore: number;
  latestPeriod: number;
  latestMinute: number;
  latestSecond: number;
  min1: number;
  min2: number;
  min3: number;
  minOt: number;
  awayShots1: number;
  awayShots2: number;
  awayShots3: number;
  awayShotsOt: number;
  homeShots1: number;
  homeShots2: number;
  homeShots3: number;
  homeShotsOt: number;
  createdAt: string;
  updatedAt: string;
}    

export interface Penalty {
  id: number;
  tenantId: number;
  statsheetId: number;
  period: number;
  minute: number;
  second: number;
  teamId: number;
  committedById: number;
  infraction: string;
  duration: number;
  severity: string;
  startPeriod: string;
  startMinute: number;
  startSecond: number;
  endPeriod: string;
  endMinute: number;
  endSecond: number;
  createdAt: string;
  updatedAt: string;
  committedByNumber: string;
}

export interface Statsheet {
  settings: Settings;
  game: Game;
  teams: Team[];
  players: Player[];
  skaters: Skater[];
  goals: Goal[];
  penalties: Penalty[];
  goaltenders: Goaltender[];
}

export interface Goaltender {
  id: number;
  type: string;
  tenantId: number;
  teamId: number;
  playerId: number;
  statsheetId: number;
  gamesPlayed: number;
  minutesPlayed: number;
  shotsAgainst: number;
  goalsAgainst: number;
  saves: number;
  savePercentage: number;
  goalsAgainstAverage: number;
  shutouts: number;
  shootoutAttempts: number;
  shootoutGoals: number;
  shootoutSavePercentage: number;
  regulationWins: number;
  regulationLosses: number;
  overtimeWins: number;
  overtimeLosses: number;
  shootoutWins: number;
  shootoutLosses: number;
  totalWins: number;
  totalLosses: number;
  createdAt: string;
  updatedAt: string;
  jerseyNumber: string;
  firstName: string;
  lastName: string;
}

export interface Action {
  type: string;
  payload: any;
}

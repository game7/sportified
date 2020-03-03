export interface Event {
  id: number;
  tenantId: number;
  divisionId: number;
  seasonId: number;
  locationId: number;
  type: string;
  startsOn: string;
  endsOn: string;
  duration: number;
  allDay: null,
  summary: string;
  description: null,
  createdAt: string;
  updatedAt: string;
  homeTeamId: number;
  awayTeamId: number;
  statsheetId: number;
  statsheetType: null,
  homeTeamScore: number;
  awayTeamScore: number;
  homeTeamName: string;
  awayTeamName: string;
  homeTeamCustomName: string;
  awayTeamCustomName: string;
  textBefore: string;
  textAfter: string;
  result: string;
  completion: string;
  excludeFromTeamRecords: boolean;
  playingSurfaceId: number;
  homeTeamLockerRoomId: number;
  awayTeamLockerRoomId: number;
  programId: number;
  pageId: number;
  private: boolean;
  tagList: null;
  editUrl: string;
  cloneUrl: string;
  deleteUrl: string;
  resultUrl?: string;
  statsheetUrl?: string;
  printScoresheetUrl?: string;
}

export interface LockerRoom {
  id: number;
  type: string;
  name: string;
  tenantId: number;
  locationId: number;
  createdAt: string;
  updatedAt: string;
}
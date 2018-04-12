import * as React from 'react';
import { Link } from 'react-router-dom'
import { Tenant, League, Season, Division, Team, Location } from '../common/store';

export type cell = string;
export type row = cell[]

interface IFile {
  name: string;
  content: string;
}

export interface IImportState {
  tenant?: Tenant,
  leagueId?: string,
  seasonId?: string,
  divisionId?: string,
  file?: IFile;
  delimiter?: string;
  hasHeader?: boolean;
  rows?: row[];
  filename?: string;
  columns? : Column[];
  teamMaps?: Map[];
  locationMaps?: Map[];
  tenants?: Tenant[];
  leagues?: League[];
  seasons?: Season[];
  divisions?: Division[];
  teams?: Team[];
  locations?: Location[];
}

export interface Column {
  pattern: string;
  property?: string;
}

export interface Map {
  key: string;
  id?: string;
  name?: string;
}

export const Properties = {
  date: 'Date',
  time: 'Time',
  duration: 'Duration',
  homeTeam: 'Home Team',
  awayTeam: 'Away Team',
  summary: 'Summary',
  prependTags: 'Tags - Prepend',
  appendTags: 'Tags - Append',
  location: 'Location',
  unused: 'Not Used'
};

export const storage = {
  save: (state: IImportState) => localStorage.setItem('import', JSON.stringify(state)),
  load: (): IImportState => JSON.parse(localStorage.getItem('import') || '{}')
}

export const Back = (props: { disabled?: boolean, to?: string }) => {
  let css = ['btn', 'btn-default'];
  if(props.disabled) css.push('disabled');
  return (
    <Link className={css.join(' ')} to={props.to || ""}>
      <i className="far fa-backward"/>{" "}Back
    </Link>
  )
}

export const Next = (props: { disabled?: boolean, to?: string }) => {
  let css = ['btn', 'btn-default'];
  if(props.disabled) css.push('disabled');
  return (
    <Link className={css.join(' ')} to={props.to || ""}>
      Next{" "}<i className="far fa-forward"/>
    </Link>
  )
}

interface HeaderProps {
  title: string;
  canNext?: boolean;
  nextUrl?: string;
  canBack?: boolean;
  backUrl?: string;
}

export const Header = (props: HeaderProps) => {
  let styles = {
    buttons: {
      float: 'right'
    },
    clearfix: {
      clear: 'both'
    }
  }
  return (
    <h1 className="page-header">
      {props.title}
      <div style={styles.buttons}>
        <div className="btn-group">
          <Back
            disabled={!props.canBack}
            to={props.backUrl}
          />
          <Next
            disabled={!props.canNext}
            to={props.nextUrl}
          />
        </div>
      </div>
      <div style={styles.clearfix} />
    </h1>
  )
}

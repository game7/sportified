import * as React from 'react';
import { Link } from 'react-router-dom'
import { Tenant, League, Season, Division, Team, Location } from '../common/store';
import { Button, ButtonGroup, Icon } from 'semantic-ui-react';

export type cell = string;
export type row = cell[]

interface IFile {
  name: string;
  content: string;
}

export interface IImportState {
  tenant?: Tenant,
  leagueId?: number,
  seasonId?: number,
  divisionId?: number,
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
  id?: string | number;
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
  return (
    <Button as="a" disabled={props.disabled} label="Back" icon="left arrow" href={props.to || ""} />
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

export const Header = ({ title, canBack = false, backUrl = "", canNext = false, nextUrl = "" }: HeaderProps) => {
  const styles = {
    buttons: {
      float: 'right'
    } as React.CSSProperties,
    clearfix: {
      clear: 'both'
    } as React.CSSProperties
  }
  return (
    <h1 className="page-header">
      {title}
      <div style={styles.buttons}>
        <Button as={Link} disabled={!canBack} content="Back" icon="left arrow" to={backUrl} labelPosition="left" />
        <Button as={Link} disabled={!canNext} content="Next" icon="right arrow" to={nextUrl} labelPosition="right" />
      </div>
      <div style={styles.clearfix} />
    </h1>
  )
}

import * as React from "react";
import { Link } from "react-router-dom";
import { Tenant, League, Season, Division, Team } from "../common/store";
import { Button } from "semantic-ui-react";

export type cell = string;
export type row = cell[];

interface IFile {
  name: string;
  content: string;
}

export interface IImportState {
  tenant?: Tenant;
  leagueId?: number;
  seasonId?: number;
  divisionId?: number;
  file?: IFile;
  delimiter?: string;
  hasHeader?: boolean;
  rows?: row[];
  filename?: string;
  columns?: Column[];
  teamMaps?: Map[];
  tenants?: Tenant[];
  leagues?: League[];
  seasons?: Season[];
  divisions?: Division[];
  teams?: Team[];
  isComplete?: boolean;
}

export interface Column {
  pattern: string;
  property?: string;
}

export interface Map {
  key: string;
  id?: number;
  name?: string;
}

export const PROPERTIES = {
  firstName: "First Name",
  lastName: "Last Name",
  team: "Team",
  jerseyNumber: "Jersey Number",
  birthdate: "Date of Birth",
  email: "Email",
  substitute: "Substitute",
  position: "Position",
  unused: "Not Used",
};

export const storage = {
  save: (state: IImportState) =>
    localStorage.setItem("sprtfd-players-import", JSON.stringify(state)),
  load: (): IImportState =>
    JSON.parse(localStorage.getItem("sprtfd-players-import") || "{}"),
};

const IMPORT_STATE_KEY = "sportified-players-import";

export function useImportState(
  initial?: IImportState
): [IImportState, (state: IImportState) => void] {
  const [state, setState] = React.useState<IImportState>(
    initial || JSON.parse(localStorage.getItem(IMPORT_STATE_KEY) || "{}")
  );

  const setAndStoreState = (state: IImportState) => {
    localStorage.setItem(IMPORT_STATE_KEY, JSON.stringify(state));
    setState(state);
  };

  return [state, setAndStoreState];
}

interface HeaderProps {
  title: string;
  canNext?: boolean;
  nextUrl?: string;
  canBack?: boolean;
  backUrl?: string;
}

export const Header = ({
  title,
  canBack = false,
  backUrl = "",
  canNext = false,
  nextUrl = "",
}: HeaderProps) => {
  const styles = {
    buttons: {
      float: "right",
    } as React.CSSProperties,
    clearfix: {
      clear: "both",
    } as React.CSSProperties,
  };
  return (
    <h1 className="page-header">
      {title}
      <div style={styles.buttons}>
        <Button
          as={Link}
          disabled={!canBack}
          content="Back"
          icon="left arrow"
          to={backUrl}
          labelPosition="left"
        />
        <Button
          as={Link}
          disabled={!canNext}
          content="Next"
          icon="right arrow"
          to={nextUrl}
          labelPosition="right"
        />
      </div>
      <div style={styles.clearfix} />
    </h1>
  );
};

import { keyBy } from "lodash";
import moment from "moment";
import { useState } from "react";
import { Button, Message, Table } from "semantic-ui-react";
import { GameUpload, Store } from "../common/store";
import { Header, IImportState, useImportState } from "./common";

const parseDuration = (value: string) => {
  const parts = value.split(":");
  if (parts.length == 2) {
    return parseInt(parts[0]) * 60 + parseInt(parts[1]);
  }
  return value;
};

export function makeGames(state: IImportState): GameUpload[] {
  let {
    columns = [],
    rows = [],
    hasHeader,
    teams = [],
    locations = [],
    teamMaps = [],
    locationMaps = [],
  } = state;
  if (hasHeader) [, ...rows] = rows;

  // for each row
  const data = rows.map((row) => {
    let item: Record<string, any> = {};
    columns.forEach((col, i) => {
      let key = col.property || "";
      switch (key) {
        case "homeTeam":
        case "awayTeam":
          item[key] = teamMaps.find((map) => map.key == row[i]);
          break;
        case "location":
          item[key] = locationMaps.find((map) => map.key == row[i]);
          break;
        default:
          item[key] = row[i];
      }
    });
    return item;
  });

  const teamsById = keyBy(teams, (team) => team.id);
  const locationsById = keyBy(locations, (loc) => loc.id);

  const games = data.map((item: any) => {
    return {
      startsOn: item.date + " " + item.time,
      duration: parseDuration(item.duration),
      location: locationsById[item.location.id],
      homeTeam: teamsById[item.homeTeam.id],
      awayTeam: teamsById[item.awayTeam.id],
      textBefore: item.textBefore,
      textAfter: item.textAfter,
      selected: true,
    } as unknown as GameUpload;
  });

  return games;
}

export default function ReviewPage() {
  const [state, setState] = useImportState();

  const [games] = useState<GameUpload[]>(makeGames(state));
  const [isProcessing, setIsProcessing] = useState(false);

  // function handleGameToggle(id: number) {
  //   return () => {
  //     setGames(
  //       games.map((game) => {
  //         if (game.id == id) {
  //           game.selected = !game.selected;
  //         }
  //         return game;
  //       })
  //     );
  //   };
  // }

  function handleCreateGames() {
    setIsProcessing(true);
    const { leagueId, seasonId, divisionId } = state;
    let payload = {
      game: games.map((g) => {
        return {
          program_id: leagueId,
          season_id: seasonId,
          division_id: divisionId,
          starts_on: moment(new Date(g.startsOn)).format("M/D/YY h:mm a"),
          duration: g.duration,
          home_team_id: g.homeTeam.id,
          away_team_id: g.awayTeam.id,
          location_id: g.location.id,
          text_before: g.textBefore,
          text_after: g.textAfter,
        };
      }),
    };
    Store.createGames(payload).then((response) => {
      if (response["ok"]) {
        alert("Games have been posted");
        setState({ ...state, isComplete: true });
      } else {
        alert("Oops!  Something didn't go right...");
      }
      setIsProcessing(false);
    });
  }

  return (
    <div>
      <Header
        title="Review"
        canBack={true}
        backUrl="/games/mapping"
        canNext={false}
      />
      <Message
        info
        icon="info circle"
        header="You're almost there!"
        content="Scroll to buttom to Submit"
      />
      <Table celled striped>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>Date / Time</Table.HeaderCell>
            <Table.HeaderCell>Duration</Table.HeaderCell>
            <Table.HeaderCell>Location</Table.HeaderCell>
            {/* <Table.HeaderCell>Summary</Table.HeaderCell> */}
            <Table.HeaderCell>Home</Table.HeaderCell>
            <Table.HeaderCell>Away</Table.HeaderCell>
            <Table.HeaderCell>Text Before</Table.HeaderCell>
            <Table.HeaderCell>Text After</Table.HeaderCell>
            {/* <Table.HeaderCell>Tags</Table.HeaderCell> */}
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {games.map((g, i) => (
            <Table.Row key={i}>
              {/* {/*
                <Table.Cell style={{textAlign: 'center'}}>
                  <input type="checkbox" checked={g.selected} onChange={this.handleGameToggle(g.id)}/>
                </Table.Cell>
                */}
              <Table.Cell>
                {moment(new Date(g["startsOn"]))
                  .format("ddd M/D/YY h:mma")
                  .replace("m", "")}
              </Table.Cell>
              <Table.Cell>{g["duration"]}</Table.Cell>
              <Table.Cell>{g["location"]["name"]}</Table.Cell>
              {/* <Table.Cell>{g['summary']}</Table.Cell> */}
              <Table.Cell>{g["homeTeam"]["name"]}</Table.Cell>
              <Table.Cell>{g["awayTeam"]["name"]}</Table.Cell>
              <Table.Cell>{g["textBefore"]}</Table.Cell>
              <Table.Cell>{g["textAfter"]}</Table.Cell>
              {/* <Table.Cell>{g['tags']}</Table.Cell> */}
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
      <Button
        primary
        onClick={handleCreateGames}
        content="Create"
        disabled={state.isComplete || isProcessing}
      />
      <p style={{ height: 20 }}> </p>
    </div>
  );
}

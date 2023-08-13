import { keyBy } from "lodash";
import moment from "moment";
import { useState } from "react";
import { Button, Message, Table } from "semantic-ui-react";
import { EventUpload, GameUpload, Store } from "../common/store";
import { Header, IImportState, useImportState } from "./common";

const parseDuration = (value: string) => {
  const parts = value.split(":");
  if (parts.length == 2) {
    return parseInt(parts[0]) * 60 + parseInt(parts[1]);
  }
  return value;
};

const mergeTags = (existing: string, next: string) => {
  if (!existing) return next;
  if (!next) return existing;
  const tags = existing.split(",");
  return [...tags, next].join(",");
};

export function makeEvents(state: IImportState): EventUpload[] {
  let {
    columns = [],
    rows = [],
    hasHeader,
    locations = [],
    locationMaps = [],
  } = state;
  if (hasHeader) [, ...rows] = rows;

  // for each row
  const data = rows.map((row) => {
    let item: Record<string, any> = {};
    columns.forEach((col, i) => {
      let key = col.property || "";
      switch (key) {
        case "location":
          item[key] = locationMaps.find((map) => map.key == row[i]);
          break;
        case "prependTags":
          item["tags"] = mergeTags(row[i], item["tags"]);
          break;
        case "appendTags":
          item["tags"] = mergeTags(item["tags"], row[i]);
          break;
        default:
          item[key] = row[i];
      }
    });
    return item;
  });

  const locationsById = keyBy(locations, (loc) => loc.id);

  const games = data.map((item: any) => {
    return {
      summary: item.summary,
      startsOn: item.date + " " + item.time,
      duration: parseDuration(item.duration),
      location: locationsById[item.location.id],
      textBefore: item.textBefore,
      textAfter: item.textAfter,
      tags: item.tags,
      selected: true,
    } as unknown as EventUpload;
  });

  return games;
}

export default function ReviewPage() {
  const [state, setState] = useImportState();

  const [events] = useState<EventUpload[]>(makeEvents(state));
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
    let payload = {
      event: events.map((g) => {
        const all_day_duration = 24 * 60;
        const duration = g.duration || all_day_duration;
        return {
          starts_on: moment(new Date(g.startsOn)).format("M/D/YY h:mm a"),
          duration: duration,
          summary: g.summary,
          home_team_custom_name: g.homeTeam,
          away_team_custom_name: g.awayTeam,
          location_id: g.location.id,
          tag_list: g.tags,
          all_day: duration == all_day_duration,
        };
      }),
    };
    Store.createEvents(payload).then((response) => {
      if (response["ok"]) {
        alert("Games have been posted");
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
        backUrl="/events/mapping"
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
            <Table.HeaderCell>Summary</Table.HeaderCell>
            {/* <Table.HeaderCell>Home</Table.HeaderCell>
              <Table.HeaderCell>Away</Table.HeaderCell> */}
            <Table.HeaderCell>Tags</Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {events.map((g, i) => (
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
              <Table.Cell>{g["summary"]}</Table.Cell>
              {/* <Table.Cell>{g['homeTeam']}</Table.Cell>
              <Table.Cell>{g['awayTeam']}</Table.Cell> */}
              <Table.Cell>{g["tags"]}</Table.Cell>
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

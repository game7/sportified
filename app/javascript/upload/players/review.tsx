import moment from "moment";
import { useState } from "react";
import { Button, Message, Table } from "semantic-ui-react";
import { PlayerUpload, Store } from "../common/store";
import { Header, IImportState, useImportState } from "./common";

export function makePlayers(state: IImportState): PlayerUpload[] {
  let { rows = [], columns = [], teamMaps = [], hasHeader, teams = [] } = state;
  if (hasHeader) [, ...rows] = rows;

  // for each row
  const data = rows.map((row) => {
    let item: Record<string, any> = {};

    columns.forEach((col, i) => {
      let key = col.property;
      switch (key) {
        case "team":
          item[key] = teamMaps.filter((map) => map.key == row[i])[0];
          break;
        case "email":
          if (row[i]) item[key] = row[i].trim().toLowerCase();
          break;
        case "position":
          if (row[i]) item[key] = row[i].trim().toUpperCase()[0];
          break;
        case "substitute":
          item[key] = row[i] && !!row[i];
          break;
        default:
          item[key || ""] = row[i];
      }
    });
    return item;
  });
  // get mapped value
  const players = data.map((item: any) => {
    return {
      firstName: item.firstName,
      lastName: item.lastName,
      team: teams.find((team) => team.id == item.team.id),
      jerseyNumber: item.jerseyNumber,
      email: item.email,
      birthdate: item.birthdate,
      position: item.position,
      substitute: item.substitute,
    } as PlayerUpload;
  });

  return players;
}

export default function ReviewPage() {
  const [state, setState] = useImportState();

  const [players] = useState<PlayerUpload[]>(makePlayers(state));
  const [isProcessing, setIsProcessing] = useState(false);
  function handleCreatePlayers() {
    setIsProcessing(true);

    let payload = {
      player: players.map((g) => {
        return {
          first_name: g.firstName,
          last_name: g.lastName,
          team_id: g.team.id,
          jersey_number: g.jerseyNumber,
          email: g.email ? g.email.toLowerCase() : null,
          birthdate: g.birthdate
            ? moment(new Date(g.birthdate)).format("M/D/YY")
            : null,
          position: g.position,
          substitute: !!g.substitute,
        };
      }),
    };
    Store.createPlayers(payload).then((response) => {
      if (response["ok"]) {
        alert("That Worked!");
        setState({ ...state, isComplete: true });
      } else {
        response["text"]().then((text) => {
          alert(`Oops!  Something didn\'t go right...\n\n${text}`);
        });
      }
      setIsProcessing(false);
    });
  }

  return (
    <div>
      <Header
        title="Review"
        canBack={true}
        backUrl="/players/mapping"
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
            <Table.HeaderCell>First</Table.HeaderCell>
            <Table.HeaderCell>Last</Table.HeaderCell>
            <Table.HeaderCell>Team</Table.HeaderCell>
            <Table.HeaderCell>#</Table.HeaderCell>
            <Table.HeaderCell>Birthdate</Table.HeaderCell>
            <Table.HeaderCell>Email</Table.HeaderCell>
            <Table.HeaderCell>Position</Table.HeaderCell>
            <Table.HeaderCell>Sub</Table.HeaderCell>
            {/* <Table.HeaderCell>Tags</Table.HeaderCell> */}
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {players.map((g, i) => (
            <Table.Row key={i}>
              {/*
              <Table.Cell style={{textAlign: 'center'}}>
                <input type="checkbox" checked={g.selected} onChange={this.handleGameToggle(g.id)}/>
              </Table.Cell>
              */}
              <Table.Cell>{g["firstName"]}</Table.Cell>
              <Table.Cell>{g["lastName"]}</Table.Cell>
              <Table.Cell>{g["team"]["name"]}</Table.Cell>
              <Table.Cell>{g["jerseyNumber"]}</Table.Cell>
              <Table.Cell>
                {g["birthdate"]
                  ? moment(new Date(g["birthdate"]))
                      .format("M/D/YY")
                      .replace("m", "")
                  : ""}
              </Table.Cell>
              <Table.Cell>{g["email"]}</Table.Cell>
              <Table.Cell>{g["position"]}</Table.Cell>
              <Table.Cell>{g["substitute"] ? "X" : ""}</Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
      <Button
        primary
        onClick={handleCreatePlayers}
        content="Create"
        disabled={isProcessing}
      />
      <p style={{ height: 20 }}> </p>
    </div>
  );
}

// class Review extends Component<
//   RouteComponentProps<IReviewProps>,
//   IReviewState
// > {
//   componentWillMount() {
//     const persistedState = storage.load();
//     this.setState({
//       ...persistedState,
//       players: makePlayers(persistedState),
//     });
//   }

//   handleCompleted = () => {
//     this.setState(
//       {
//         file: undefined,
//         delimiter: undefined,
//         hasHeader: undefined,
//         rows: undefined,
//         columns: undefined,
//         teamMaps: undefined,
//       },
//       () => storage.save(this.state)
//     );
//     this.props.history.push("/players");
//   };

//   handleCreatePlayers = () => {
//     this.setState({ isProcessing: true });
//     let payload = {
//       player: this.state.players.map((g) => {
//         return {
//           first_name: g.firstName,
//           last_name: g.lastName,
//           team_id: g.team.id,
//           jersey_number: g.jerseyNumber,
//           email: g.email ? g.email.toLowerCase() : null,
//           birthdate: g.birthdate
//             ? moment(new Date(g.birthdate)).format("M/D/YY")
//             : null,
//           position: g.position,
//           substitute: !!g.substitute,
//         };
//       }),
//     };
//     Store.createPlayers(payload).then((response) => {
//       if (response["ok"]) {
//         alert("That Worked!");
//         this.setState({ isCompleted: true });
//       } else {
//         response["text"]().then((text) => {
//           alert(`Oops!  Something didn\'t go right...\n\n${text}`);
//           this.setState({ isProcessing: false });
//         });
//       }
//     });
//   };

//   render() {
//     const { isProcessing } = this.state;

//     return (
//       <div>
//         <Header
//           title="Review"
//           canBack={true}
//           backUrl="/games/mapping"
//           canNext={false}
//         />
//         <Message
//           info
//           icon="info circle"
//           header="You're almost there!"
//           content="Scroll to buttom to Submit"
//         />
//         <Table celled striped>
//           <Table.Header>
//             <Table.Row>
//               <Table.HeaderCell>First</Table.HeaderCell>
//               <Table.HeaderCell>Last</Table.HeaderCell>
//               <Table.HeaderCell>Team</Table.HeaderCell>
//               <Table.HeaderCell>#</Table.HeaderCell>
//               <Table.HeaderCell>Birthdate</Table.HeaderCell>
//               <Table.HeaderCell>Email</Table.HeaderCell>
//               <Table.HeaderCell>Position</Table.HeaderCell>
//               <Table.HeaderCell>Sub</Table.HeaderCell>
//               {/* <Table.HeaderCell>Tags</Table.HeaderCell> */}
//             </Table.Row>
//           </Table.Header>
//           <Table.Body>
//             {this.state.players.map((g, i) => (
//               <Table.Row key={i}>
//                 {/*
//               <Table.Cell style={{textAlign: 'center'}}>
//                 <input type="checkbox" checked={g.selected} onChange={this.handleGameToggle(g.id)}/>
//               </Table.Cell>
//               */}
//                 <Table.Cell>{g["firstName"]}</Table.Cell>
//                 <Table.Cell>{g["lastName"]}</Table.Cell>
//                 <Table.Cell>{g["team"]["name"]}</Table.Cell>
//                 <Table.Cell>{g["jerseyNumber"]}</Table.Cell>
//                 <Table.Cell>
//                   {g["birthdate"]
//                     ? moment(new Date(g["birthdate"]))
//                         .format("M/D/YY")
//                         .replace("m", "")
//                     : ""}
//                 </Table.Cell>
//                 <Table.Cell>{g["email"]}</Table.Cell>
//                 <Table.Cell>{g["position"]}</Table.Cell>
//                 <Table.Cell>{g["substitute"] ? "X" : ""}</Table.Cell>
//               </Table.Row>
//             ))}
//           </Table.Body>
//         </Table>
//         <Button
//           primary
//           onClick={this.handleCreatePlayers}
//           content="Create"
//           disabled={isProcessing}
//         />
//         <p style={{ height: 20 }}> </p>
//       </div>
//     );
//   }
// }

// render() {
//   let createButtonCss = ['btn', 'btn-primary'];
//   if(this.state.isProcessing) {
//     createButtonCss.push('disabled');
//   }
//   let completedButtonCss = ['btn', 'btn-primary'];
//   if(!this.state.isCompleted) {
//     completedButtonCss.push('disabled');
//   }
//   return (
//     <div>
//       <Header
//         title="Review"
//         canBack={true}
//         backUrl="/players/mapping"
//         canNext={false}
//       />
//       <p>
//         <em>Scroll to review and submit</em>
//       </p>
//       <table className="table table-bordered table-striped">
//         <thead>
//           <tr>
//             <th>First</th>
//             <th>Last</th>
//             <th>Team</th>
//             <th>#</th>
//             <th>Birthdate</th>
//             <th>Email</th>
//             <th>Pos</th>
//             <th>Sub</th>
//           </tr>
//         </thead>
//         <tbody>
//           {this.state.players.map((g, i)=> (
//             <tr key={i}>
//               {/*
//               <Table.Cell style={{textAlign: 'center'}}>
//                 <input type="checkbox" checked={g.selected} onChange={this.handleGameToggle(g.id)}/>
//               </Table.Cell>
//               */}
//               <Table.Cell>{g['firstName']}</Table.Cell>
//               <Table.Cell>{g['lastName']}</Table.Cell>
//               <Table.Cell>{g['team']['name']}</Table.Cell>
//               <Table.Cell>{g['jerseyNumber']}</Table.Cell>
//               <Table.Cell>{g['birthdate'] ? moment(new Date(g['birthdate'])).format('M/D/YY').replace('m','') : ''}</Table.Cell>
//               <Table.Cell>{g['email']}</Table.Cell>
//               <Table.Cell>{g['position']}</Table.Cell>
//               <Table.Cell>{g['substitute'] ? 'X' : ''}</Table.Cell>
//             </tr>
//           ))}
//         </tbody>
//       </table>
//       <button className={createButtonCss.join(' ')} onClick={this.handleCreatePlayers}>Create Players</button>
//       {" "}
//       <button className={completedButtonCss.join(' ')} onClick={this.handleCompleted}>Done</button>
//       <p style={{height: 20}}> </p>
//     </div>
//   );
// }

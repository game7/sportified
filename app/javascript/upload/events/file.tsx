import { ChangeEvent, useRef } from "react";
import { Button, Input } from "semantic-ui-react";
import { Header, useImportState } from "./common";

export default function FilePage() {
  const [state, setState] = useImportState();

  const fileInputRef = useRef<HTMLInputElement>(null);

  const canMoveNext = !!state.file;

  // handleStartOver = () => {
  //   setState(
  //     {
  //       file: undefined,
  //       delimiter: undefined,
  //       hasHeader: undefined,
  //       rows: undefined,
  //       filename: undefined,
  //       columns: undefined,
  //     }
  //   );
  // };

  function handleFileSelect(event: ChangeEvent<HTMLInputElement>) {
    if (!event.target.files) {
      return;
    }

    let file = event.target.files[0];

    if (!file) {
      return;
    }

    let reader = new FileReader();
    reader.onload = (e: any) => {
      setState({
        ...state,
        file: {
          name: file.name,
          content: e.target.result,
        },
        delimiter: undefined,
        hasHeader: undefined,
        rows: undefined,
        columns: undefined,
        teamMaps: undefined,
        locationMaps: undefined,
      });
    };
    reader.readAsText(file);
  }

  return (
    <div>
      <Header
        title="File"
        canBack={false}
        canNext={canMoveNext}
        nextUrl="/events/data"
      />
      <div style={{ display: "none" }}>
        <input
          type="file"
          ref={fileInputRef}
          onChange={handleFileSelect}
        ></input>
      </div>
      <Input type="text" action value={state.file ? state.file.name : ""}>
        <input />
        <Button
          content="Upload File"
          onClick={() => {
            fileInputRef.current?.click();
          }}
        />
      </Input>
      {state.file && (
        <pre
          style={{ minHeight: 100, padding: 10, border: "1px solid #dedede" }}
        >
          {state.file.content}
        </pre>
      )}
    </div>
  );
}

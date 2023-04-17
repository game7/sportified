import { useEffect } from "react";
import { Checkbox, CheckboxProps, Table } from "semantic-ui-react";
import { Header, row, useImportState } from "./common";

const delimiters = [",", "|", "\t"];

export function findDelimiter(content: string): string {
  return delimiters.filter((d) => content.indexOf(d) !== -1)[0];
}

export function makeRows(content: string, delimiter: string): row[] {
  return content
    .replace(/\r/g, "")
    .split("\n")
    .filter((row) => row != "")
    .map((row) => row.split(delimiter));
}

export default function DataPage() {
  const [state, setState] = useImportState();
  const { rows = [], hasHeader = false } = state;

  useEffect(() => {
    const delimiter =
      state.delimiter || findDelimiter(state.file?.content || "");
    if (!state.rows) {
      const rows = makeRows(state.file?.content || "", delimiter);
      setState({
        ...state,
        delimiter,
        rows,
      });
    }
  }, []);

  function handleHeaderRowChange(_: unknown, data: CheckboxProps) {
    setState({
      ...state,
      hasHeader: data.checked,
      teamMaps: undefined,
    });
  }

  const canMoveNext = rows.length > 0;

  const data = [...rows];
  const header = hasHeader && data.splice(0, 1)[0];

  return (
    <div>
      <Header
        title="Data"
        canBack={true}
        backUrl="/players/file"
        canNext={canMoveNext}
        nextUrl="/players/columns"
      />
      <Checkbox
        label="Has Header Row"
        onChange={handleHeaderRowChange}
        checked={hasHeader}
      />
      <Table celled striped>
        {header && (
          <Table.Header>
            <Table.Row>
              {header.map((column) => (
                <Table.HeaderCell key={column}>{column}</Table.HeaderCell>
              ))}
            </Table.Row>
          </Table.Header>
        )}
        <Table.Body>
          {data.map((row, i) => (
            <Table.Row key={i}>
              {row.map((cell, j) => (
                <Table.Cell key={j}>{cell}</Table.Cell>
              ))}
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </div>
  );
}

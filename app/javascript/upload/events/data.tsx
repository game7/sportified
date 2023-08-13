import { useEffect } from "react";
import { Checkbox, CheckboxProps, Table } from "semantic-ui-react";
import { Header, row, useImportState } from "./common";
import { isArray } from "lodash";

const delimiters = [",", "|", "\t"];

export function findDelimiter(content: string): string {
  return delimiters.filter((d) => content.indexOf(d) !== -1)[0];
}

function csvToArray(text: string, delimiter: string = ",") {
  let p = "",
    row = [""],
    ret = [row],
    i = 0,
    r = 0,
    s = !0,
    l;
  for (l of text) {
    if ('"' === l) {
      if (s && l === p) row[i] += l;
      s = !s;
    } else if (delimiter === l && s) l = row[++i] = "";
    else if ("\n" === l && s) {
      if ("\r" === p) row[i] = row[i].slice(0, -1);
      row = ret[++r] = [(l = "")];
      i = 0;
    } else row[i] += l;
    p = l;
  }
  // drop last row if it contains a single entry (empty string)
  return ret.filter((row) => row.length > 1);
}

export default function DataPage() {
  const [state, setState] = useImportState();
  const { rows = [], hasHeader = false } = state;

  useEffect(() => {
    const delimiter =
      state.delimiter || findDelimiter(state.file?.content || "");
    if (!state.rows) {
      const rows = csvToArray(state.file?.content || "", delimiter);
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
      locationMaps: undefined,
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
        backUrl="/events"
        canNext={canMoveNext}
        nextUrl="/events/columns"
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

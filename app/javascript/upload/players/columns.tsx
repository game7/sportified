import { useEffect } from "react";
import { DropdownProps, Select, Table } from "semantic-ui-react";
import { Column, Header, PROPERTIES, row, useImportState } from "./common";

function findPropertyForPattern(pattern: string): string {
  const match = Object.entries(PROPERTIES).find(
    ([key, value]) =>
      value.toLowerCase().includes(pattern.toLowerCase()) ||
      pattern.toLowerCase().includes(value.toLowerCase())
  );
  return match ? match[0] : "";
}

export function makeColumns(row: row): Column[] {
  return row.map((col) => {
    return {
      pattern: col,
      property: findPropertyForPattern(col),
    };
  }) as Column[];
}

function getProperties() {
  return Object.entries(PROPERTIES).map(([key, value]) => ({ key, value }));
}

export default function ColumnsPage() {
  const [state, setState] = useImportState();

  useEffect(() => {
    if (!state.columns && state.rows) {
      const columns = makeColumns(state.rows[0]);
      setState({
        ...state,
        columns,
      });
    }
  }, []);

  function makeColumnChangeHandler(key: string) {
    return function handleColumnChange(event: any, data: DropdownProps) {
      const value = data.value?.toString();
      const columns = state.columns?.map((column, i) => {
        if (column.pattern == key) {
          column.property = value;
        }
        return column;
      });
      setState({ ...state, columns: columns });
    };
  }

  const { columns = [] } = state;

  const properties = getProperties();

  const canMoveNext = (function (columns) {
    const columnCount = columns.length;
    const mappedCount = columns.filter((col) => !!col.property).length;
    return columnCount > 0 && columnCount == mappedCount;
  })(columns);

  return (
    <div>
      <Header
        title="Columns"
        canBack={true}
        backUrl="/players/data"
        canNext={canMoveNext}
        nextUrl="/players/mapping"
      />
      <Table celled striped>
        <Table.Body>
          {columns.map((col, i) => (
            <Table.Row key={i}>
              <Table.Cell>{col.pattern}</Table.Cell>
              <Table.Cell>
                <Select
                  value={col.property}
                  onChange={makeColumnChangeHandler(col.pattern)}
                  options={[
                    { key: "blank" },
                    ...properties.map((prop) => ({
                      text: prop.value,
                      value: prop.key,
                    })),
                  ]}
                />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </div>
  );
}

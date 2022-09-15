
import { useEffect, useState } from 'react';
import { DropdownProps, Select, Table } from 'semantic-ui-react';
import { Column, Header, Properties, row, storage } from './common';

function findPropertyForPattern(pattern: string): string {
  for (var key in Properties) {
    if (Properties[key].toLowerCase().indexOf(pattern.toLowerCase()) != -1) {
      return key;
    }
  }
  return '';
}

export function makeColumns(row: row): Column[] {
  return row.map(col => {
    return {
      pattern: col,
      property: findPropertyForPattern(col)
    }
  }) as Column[];
}

function getProperties() {
  return Object.keys(Properties).map(key => { return { key: key, value: Properties[key] } });
}

export default function Columns() {
  const [state, setState] = useState(storage.load());

  useEffect(() => storage.save(state), [state])

  useEffect(() => {
    if (!state.columns) {
      const columns = makeColumns(state.rows[0])
      setState(state => ({
        ...state,
        columns
      }))
    }
  }, [])

  const canMoveNext = (() => {
    const columns = (state.columns || []);
    const columnCount = columns.length;
    const mappedCount = columns.filter(col => !!col.property).length;
    return columnCount > 0 && columnCount == mappedCount;
  })()


  function handleColumnChange(key: string) {
    return function columnChangeHandler(_, data: DropdownProps) {
      const value = data.value as string;
      const columns = state.columns.map((column) => {
        if (column.pattern == key) {
          return {
            ...column,
            property: value
          }
        }
        return column;
      })
      setState(state => ({ ...state, columns }))
    }
  }

  const { columns = [] } = state;
  const properties = getProperties();

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
                  onChange={handleColumnChange(col.pattern)}
                  options={[{ key: "blank" }, ...properties.map(prop => ({ text: prop.value, value: prop.key }))]}
                />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </div>
  );
}

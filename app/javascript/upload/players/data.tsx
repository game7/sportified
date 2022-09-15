
import { useEffect, useState } from 'react';
import { Checkbox, CheckboxProps, Table } from 'semantic-ui-react';
import { Header, row, storage } from './common';

const delimiters = [',', '|', '\t'];

export function findDelimiter(content: string): string {
  return delimiters.filter(d => content.indexOf(d) !== -1)[0];
}

export function makeRows(content: string, delimiter: string): row[] {
  return content.replace(/\r/g, '').split('\n').filter(row => row != '').map(row => row.split(delimiter));
}

export default function Data() {
  const [state, setState] = useState(storage.load());

  useEffect(() => storage.save(state), [state])

  useEffect(() => {
    let { delimiter, file, rows } = state;
    delimiter = delimiter || findDelimiter(file.content)
    rows = rows || makeRows(file.content, delimiter);
    setState(state => ({ ...state, delimiter, rows }))
  }, [])


  function handleHeaderRowChange(_, data: CheckboxProps) {
    setState(state => ({
      ...state,
      hasHeader: data.checked,
      teamMaps: undefined
    }))
  }

  const { rows = [], hasHeader = false } = state;

  const canMoveNext = (rows.length > 0);
  const data = [...rows]
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
      <Checkbox label="Has Header Row" onChange={handleHeaderRowChange} checked={hasHeader} />
      <Table celled striped>
        {header && (
          <Table.Header>
            <Table.Row>
              {header.map(column => (
                <Table.HeaderCell key={column}>{column}</Table.HeaderCell>
              ))}
            </Table.Row>
          </Table.Header>
        )}
        <Table.Body>
          {data.map((row, i) => (
            <Table.Row key={i}>
              {row.map(cell => (
                <Table.Cell key={cell}>{cell}</Table.Cell>
              ))}
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </div>
  );
}

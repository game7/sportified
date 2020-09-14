import * as React from 'react';
import { Component } from 'react';
import { IImportState, Header, row, storage } from './common';
import { Table, Checkbox, CheckboxProps } from 'semantic-ui-react';

const delimiters = [',', '|', '\t'];

export function findDelimiter(content: string): string {
  return delimiters.filter(d => content.indexOf(d) !== -1)[0];
}

export function makeRows(content: string, delimiter: string): row[] {
  return content.replace(/\r/g,'').split('\n').filter(row => row != '').map(row => row.split(delimiter));
}

export default class Data extends Component<{},IImportState> {

  componentDidMount() {
    let state = storage.load();
    if(!state.delimiter) {
      state.delimiter = findDelimiter(state.file.content);
    }
    if(!state.rows) {
      state.rows = makeRows(state.file.content, state.delimiter);
    }
    this.setState(state);
  }

  handleHeaderRowChange = (_event, data: CheckboxProps) => {
    this.setState({
      hasHeader: data.checked,
      teamMaps: undefined,
      locationMaps: undefined
    }, () => storage.save(this.state))
  }

  render() {
    const state = this.state || {};
    const { rows = [], hasHeader = false} = state;
    const canMoveNext = (rows.length > 0);
    
    const data = [...rows]
    const header = hasHeader && data.splice(0, 1)[0];      

    return (
      <div>
        <Header
          title="Data"
          canBack={true}
          backUrl="/games"
          canNext={canMoveNext}
          nextUrl="/games/columns"
        />
        <Checkbox label="Has Header Row" onChange={this.handleHeaderRowChange} checked={hasHeader} />
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
}


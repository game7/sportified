import * as React from 'react';
import { Component } from 'react';
import * as _ from 'lodash';
import { IImportState, Header, row, storage, Column, Properties } from './common';
import { Table, Select, DropdownProps } from 'semantic-ui-react';

function findPropertyForPattern(pattern: string): string {
  for(var key in Properties) {
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

export default class Data extends Component<{},IImportState> {

  componentWillMount() {
    let state = storage.load();
    state.columns = state.columns || makeColumns(state.rows[0])
    this.setState(state)
    storage.save(state)
  }

  get canMoveNext(): boolean {
    const columns = (this.state.columns || []);
    const columnCount = columns.length;
    const mappedCount = columns.filter(col => !!col.property).length;
    return columnCount > 0 && columnCount == mappedCount;
  }

  handleColumnChange = (key: string) => (event: any, data: DropdownProps) => {
    const value = data.value.toString();
    const state = Object.assign({}, this.state);
    const columns = state.columns.map((column, i) => {
      if (column.pattern == key) {
        column.property = value;
      }
      return column;
    })
    this.setState({ columns: columns }, () => storage.save(this.state));
  }

  render() {
    const state = (this.state || {});
    const { columns = [] } = state;
    const properties = getProperties();
    const canMoveNext = (function(columns) {
      const columnCount = columns.length;
      const mappedCount = columns.filter(col => !!col.property).length;
      return columnCount > 0 && columnCount == mappedCount;
    })(columns);
    console.log(state)
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
                    onChange={this.handleColumnChange(col.pattern)} 
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
}

let Row = ({column, properties, onChange}) => (
  <tr>
    <td>{column.pattern}</td>
    <td>
      <select className="form-control" value={column.property} onChange={onChange(column.pattern)}>
        <option value=""></option>
        {properties.map(prop => (<option key={prop.key} value={prop.key}>{prop.value}</option>))}
      </select>
    </td>
  </tr>
)

import * as React from 'react';
import { Component } from 'react';
import * as _ from 'lodash';
import { IImportState, Header, row, storage, Column, Properties } from './common';

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

  get properties(): { key: string, value: any }[] {
    return Object.keys(Properties).map(key => { return { key: key, value: Properties[key] } });
  }

  handleColumnChange = (key: string) => (event: any) => {
    const value = event.target.value;
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
    console.log('render', new Date())
    return (
      <div>
        <Header
          title="Columns"
          canBack={true}
          backUrl="/players/import/data"
          canNext={this.canMoveNext}
          nextUrl="/players/import/mapping"
        />
        <table className="table table-bordered">
          <tbody>
            {this.state.columns.map((col) => (
              <Row
                column={col}
                key={col.pattern}
                properties={this.properties}
                onChange={this.handleColumnChange}
              />
            ))}
          </tbody>
        </table>
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

import React, { FC, useState } from 'react';
import { Table, Header, Icon } from 'semantic-ui-react'
import * as moment from 'moment'

interface YearPickerProps {
  date: Date,
  onSelect: (date: Date) => void,
  onYearClick?: () => void
}

export const YearPicker: FC<YearPickerProps> = (props) => {

  const [ date, setDate ] = useState(props.date)
  const {
    onSelect,
    onYearClick = () => {}
  } = props;
  const rows = [1, 2, 3];
  const columns = [1, 2, 3, 4];
  const baseYear = Math.floor(moment(date).year() / 10) * 10;

  function renderYear(row, col) {
     const delta = (row - 1) * 4 + (col - 1);
     const year = moment(date).year(baseYear).add(delta, 'year')
    return (
      <Table.Cell key={col} selectable style={{ cursor: 'pointer' }} onClick={() => { onSelect(year.toDate()) }}>
        {year.format('YYYY')}
      </Table.Cell>
    )
  }

  function previousDecade() {
    setDate(moment(date).add(-10, 'year').toDate())
  }

  function nextDecade() {
    setDate(moment(date).add(10, 'year').toDate())
  }

  return (
    <React.Fragment>
      <Table type="basic" style={{ border: 0, marginBottom: 0 }}>
        <Table.Body>
          <Table.Row>
            <Table.Cell textAlign="left" collapsing>
              <Icon name="chevron circle left" onClick={previousDecade} style={{cursor:'pointer'}}/>
            </Table.Cell>
            <Table.Cell textAlign="center" verticalAlign="middle">
              <Header size="small" style={{cursor:'pointer'}} onClick={onYearClick}>{moment(date).year(baseYear).format('YYYY')} - {moment(date).year(baseYear).add(11, 'year').format('YYYY')}</Header>
            </Table.Cell>
            <Table.Cell textAlign="right" collapsing>
              <Icon name="chevron circle right" onClick={nextDecade} style={{cursor:'pointer'}}/>
            </Table.Cell>
          </Table.Row>
        </Table.Body>
      </Table>
      <Table columns={4} textAlign="center" celled style={{ marginTop: 0 }}>
        <Table.Body>
          {rows.map(row => (
            <Table.Row key={row}>
              {columns.map(col => renderYear(row, col))}
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </React.Fragment>
  )
}

export default YearPicker;

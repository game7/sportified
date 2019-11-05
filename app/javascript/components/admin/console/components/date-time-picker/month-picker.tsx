import React, { FC, useState } from 'react';
import { Table, Header, Icon } from 'semantic-ui-react'
import { times } from '../../utils'
import * as moment from 'moment'

interface MonthPickerProps {
  date: Date,
  onSelect: (date: Date) => void,
  onYearClick?: () => void
}

export const MonthPicker: FC<MonthPickerProps> = (props) => {

  const [ date, setDate ] = useState(props.date)
  const {
    onSelect,
    onYearClick = () => {}
  } = props;
  const rows = [1, 2, 3];
  const columns = [1, 2, 3, 4];
  const baseMonth = moment(date).startOf('year');

  function previousYear() {
    setDate(moment(date).add(-1, 'year').toDate())
  }

  function nextYear() {
    setDate(moment(date).add(1, 'year').toDate())
  }

  return (
    <React.Fragment>
      <Table type="basic" style={{ border: 0, marginBottom: 0 }}>
        <Table.Body>
          <Table.Row>
            <Table.Cell textAlign="left" collapsing>
              <Icon name="chevron circle left" onClick={previousYear} style={{cursor:'pointer'}}/>
            </Table.Cell>
            <Table.Cell textAlign="center" verticalAlign="middle">
              <Header size="small" style={{cursor:'pointer'}} onClick={onYearClick}>{moment(date).format('YYYY')}</Header>
            </Table.Cell>
            <Table.Cell textAlign="right" collapsing>
              <Icon name="chevron circle right" onClick={nextYear} style={{cursor:'pointer'}}/>
            </Table.Cell>
          </Table.Row>
        </Table.Body>
      </Table>
      <Table columns={4} textAlign="center" celled style={{ marginTop: 0 }}>
        <Table.Body>
          {times(3).map((_, row) => (
            <Table.Row key={row}>
              {times(4).map((_, col) => (
                <Table.Cell
                  key={col}
                  selectable
                  style={{ cursor: 'pointer' }}
                  onClick={() => { onSelect(moment(date).month((row * 4) + col).toDate()) }}
                >
                  {moment(date).month((row * 4) + col).format('MMMM')}
                </Table.Cell>
              ))}
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </React.Fragment>
  )
}

export default MonthPicker;

import React, { useState, FC } from 'react';
import { Table, Header, Icon } from 'semantic-ui-react'
import * as moment from 'moment';

interface HourPickerProps {
  date: Date;
  showDate: Boolean;
  onSelect: (date: Date) => void;
  onDateClick: () => void;
}

export const HourPicker: FC<HourPickerProps> = (props) => {

  const [date, setDate] = useState(props.date)
  const { showDate, onSelect, onDateClick = () => {} } = props

  function prevDay() {
    setDate(moment(date).add(-1, 'day').toDate())
  }

  function nextDay() {
    setDate(moment(date).add(1, 'day').toDate())
  }

  return (
    <React.Fragment>
      {showDate &&
        <Table type="basic" style={{ border: 0, marginBottom: 0 }}>
          <Table.Body>
            <Table.Row>
              <Table.Cell textAlign="left" collapsing>
                <Icon name="chevron left" onClick={prevDay} style={{cursor:'pointer'}}/>
              </Table.Cell>
              <Table.Cell textAlign="center" verticalAlign="middle">
                <Header size="small" style={{cursor:'pointer'}} onClick={onDateClick}>{moment(date).format('MMM D, YYYY')}</Header>
              </Table.Cell>
              <Table.Cell textAlign="right" collapsing>
                <Icon name="chevron right" onClick={nextDay} style={{cursor:'pointer'}}/>
              </Table.Cell>
            </Table.Row>
          </Table.Body>
        </Table>
      }
      <Table celled textAlign="center" style={{ marginTop: 0 }}>
        <Table.Body>
          {'x'.repeat(6).split('').map((_value, row) => (
            <Table.Row key={row}>
              {'x'.repeat(4).split('').map((_value, col) => (
                <Table.Cell
                  key={col}
                  selectable
                  style={{ cursor: 'pointer' }}
                  onClick={() => { onSelect(moment(date).hour(row * 4 + col).toDate()) }}
                >
                  {moment(date).hour(row * 4 + col).minute(0).format("h:mm A")}
                </Table.Cell>
              ))}
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </React.Fragment>
  )
}

export default HourPicker;

import React, { FC, useState } from 'react';
import { Table, Header, Icon } from 'semantic-ui-react'
import * as moment from 'moment';

interface MinutePickerProps {
  date: Date;
  showDate: Boolean;
  onSelect: (date: Date) => void;
  onDateClick: () => void;
}

export const MinutePicker: FC<MinutePickerProps> = (props) => {
  const { showDate, onDateClick, onSelect } = props
  const [ date, setDate ] = useState(props.date)

  const rows = [
    [0, 5, 10, 15],
    [20, 25, 30, 35],
    [40, 45, 50, 55]
  ]
  const hour = moment(date).hour();

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
          {rows.map((row, i) => (
              <Table.Row key={i}>
                {row.map(minute => (
                  <Table.Cell key={minute} selectable style={{ cursor: 'pointer' }} onClick={() => { onSelect(moment(date).minute(minute).toDate()) }}>{moment(date).minute(minute).format('h:mm A')}</Table.Cell>
                ))}
              </Table.Row>
            ))
          }
        </Table.Body>
      </Table>
    </React.Fragment>
  )
}

export default MinutePicker;

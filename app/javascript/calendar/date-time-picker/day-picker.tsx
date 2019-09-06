import React, { FC, useState } from 'react';
import { Table, Header, Icon } from 'semantic-ui-react'
import * as moment from 'moment'

interface DayPickerProps {
  date: Date,
  onSelect: (date: Date) => void,
  onMonthClick?: () => void
}

export const DayPicker: FC<DayPickerProps> = (props) => {

  const [ date, setDate ] = useState(props.date)
  const {
    onSelect,
    onMonthClick = () => {}
  } = props;
  const weekdays = "SMTWTFS".split('');

  function previousMonth() {
    setDate(moment(date).add(-1, 'month').toDate())
  }

  function nextMonth() {
    setDate(moment(date).add(1, 'month').toDate())
  }

  function renderDays() {
    const rows = [];
    let day = moment(date).startOf('month').startOf('week').add(-1,'day');

    while(moment(day).add(1,'day').month() != moment(date).add(1,'month').month()){
      rows.push(
        <Table.Row key={day.format('YYMMDD')}>
          {[...Array(7).keys()].map(()=>{
            day.add(1,'day');
            return renderDayCalendarCell(day);
          })}
        </Table.Row>
      )
    }
    return rows;
  }

  function renderDayCalendarCell(day){
    let cellDay = moment(day);
    let isSelected = cellDay.format('YYMMDD') == moment(date).format('YYMMDD');
    let isToday = cellDay.format('YYMMDD') == moment().format('YYMMDD');
    let isCurrentMonth = cellDay.month() != moment(date).month();
    return (
      <Table.Cell
        key={cellDay.format('YYMMDD')}
        disabled={isCurrentMonth}
        onClick={() => { onSelect(cellDay.toDate()) }}
        selectable
        style={{
          textDecoration: isToday && 'underline',
          fontWeight: isToday && 'bold',
          cursor: 'pointer',
          backgroundColor: isSelected && 'blue',
          color: isSelected && 'white'
        }}
      >
        {cellDay.format('D')}
      </Table.Cell>
    )
}

  return (
    <React.Fragment>
      <Table type="basic" style={{ border: 0, marginBottom: 0 }}>
        <Table.Body>
          <Table.Row>
            <Table.Cell textAlign="left" collapsing>
              <Icon name="chevron circle left" onClick={previousMonth} style={{cursor:'pointer'}}/>
            </Table.Cell>
            <Table.Cell textAlign="center" verticalAlign="middle">
              <Header size="small" style={{cursor:'pointer'}} onClick={onMonthClick}>{moment(date).format('MMMM YYYY')}</Header>
            </Table.Cell>
            <Table.Cell textAlign="right" collapsing>
              <Icon name="chevron circle right" onClick={nextMonth} style={{cursor:'pointer'}}/>
            </Table.Cell>
          </Table.Row>
        </Table.Body>
      </Table>
      <Table columns={7} textAlign="center" celled style={{ marginTop: 0 }}>
        <Table.Header>
          {weekdays.map((weekday, i) => (<Table.HeaderCell key={i}> {weekday} </Table.HeaderCell>))}
        </Table.Header>
        <Table.Body>
          {renderDays()}
        </Table.Body>
      </Table>
    </React.Fragment>
  )
}

export default DayPicker;

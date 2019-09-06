import React, { FC, useState } from 'react';
import { Form, Popup, Table, Header, Icon } from 'semantic-ui-react'
import * as moment from 'moment'
import MinutePicker from './minute-picker';
import HourPicker from './hour-picker';
import DayPicker from './day-picker';
import MonthPicker from './month-picker';
import YearPicker from './year-picker';

export type DateTimePickerType = 'date' | 'time' | 'datetime';

interface Props {
  type?: DateTimePickerType;
  label?: string;
  value?: Date | string;
  onSelect?: (value: Date) => void
  trigger: React.ReactNode
}

type View = 'year' | 'month' | 'day' | 'hour' | 'minute';

export const DateTimePicker: FC<Props> = (props) => {

  const {
    type = 'datetime',
    label,
    onSelect = (_value) => {},
    trigger
  } = props;

  const [view, setView] = useState<View>()
  const [value, setValue] = useState(props.value ? moment(props.value).toDate() : moment().toDate())
  const [open, setOpen] = useState(false)

  function yearSelected(date: Date) {
    setValue(date)
    setView('month')
  }

  function monthSelected(date: Date) {
    setValue(date)
    setView('day')
  }

  function daySelected(date: Date) {
    setValue(date)
    setView('hour')
    if(type === 'date') {
      onSelect(date)
      setOpen(false)
    }
  }

  function hourSelected(date: Date) {
    setValue(date)
    setView('minute')
  }

  function minuteSelected(date: Date) {
    setValue(date)
    onSelect(date)
    setOpen(false)
  }

  function handleOpen() {
    setView(type === 'time' ? 'hour' : 'day')
    setOpen(true)
  }

  function handleClose() {
    setOpen(false)
  }

  const content = (() => {
    if(view == 'minute') return <MinutePicker date={value} onSelect={minuteSelected} showDate={type !== 'time'} onDateClick={() => setView('day')} />
    if(view == 'hour') return <HourPicker date={value} onSelect={hourSelected} showDate={type !== 'time'} onDateClick={() => setView('day')} />
    if(view == 'day') return <DayPicker date={value} onSelect={daySelected} onMonthClick={() => setView('month')} />
    if(view == 'month') return <MonthPicker date={value} onSelect={monthSelected} onYearClick={() => { setView('year') }} />
    if(view == 'year') return <YearPicker date={value} onSelect={yearSelected} onYearClick={() => {}} />
  })()
  return (
    <Form.Field>
      <label>{label}</label>
      <Popup trigger={trigger} open={open} on="click" position="bottom left" onOpen={handleOpen} onClose={handleClose} content={content} wide="very" hoverable style={{ padding: 0, width: 400 }}  />
    </Form.Field>
  )
}

export default DateTimePicker;


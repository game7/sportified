import React, { FC, useState, useEffect } from 'react'
import * as moment from 'moment';
import { Form } from 'semantic-ui-react';
import { DateTimePicker, DateTimePickerType } from './date-time-picker';

interface Props {
  type?: DateTimePickerType
  value?: string | Date;
  format?: string;
  label: string;
  onChange?: (value: string) => void;
}

const FORMATS = {
  date: 'M/D/YY',
  time: 'h:mm a',
  datetime: 'M/D/YY h:mm a'
}

export const DateTimeInput: FC<Props> = (props) => {
  const { type = 'datetime' } = props;
  const {
    format = FORMATS[type],
    label,
    onChange = () => {}
  } = props;
  const [value, setValue] = useState(props.value);
  useEffect(() => {
    setValue(props.value)
  }, [ props.value ])
  const Input = <input value={value && moment(value).format(format)} onChange={() => {}} style={{ width: 120 }} />
  function handleSelect(value: Date) {
    const val = moment(value).format(format)
    setValue(val)
    onChange(val)
  }
  return (
    <Form.Field>
      <label>{label}</label>
      <DateTimePicker trigger={Input} type={type} value={value} onSelect={handleSelect}/>
    </Form.Field>
  )
}

export default DateTimeInput;

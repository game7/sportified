import React, { FC, useState, useEffect } from 'react';
import { Form, CheckboxProps } from 'semantic-ui-react';
import { Season } from '../../actions/seasons';
import { Division, list } from '../../actions/divisions';
import { DateTimeInput } from '../../components/date-time-input'
import * as moment from 'moment';

interface P {
  data?: Partial<Season>
  divisions: Division[]
  loading?: boolean
  onSubmit: (data: Partial<Season>, setErrors: (errors: any) => void) => void
}

const SeasonForm: FC<P> = (props) => {
  const {
    onSubmit,
    loading = false,
    divisions = []
  } = props

  const [data, setData] = useState(props.data || {})
  const [errors, setErrors] = useState({})

  useEffect(() => {
    const {
      name = '',
      startsOn = '',
      divisionIds = []
    } = props.data
    setData({ name, startsOn, divisionIds })
  }, [props.data])

  function bind(attr: keyof Season) {
    return function(event: React.ChangeEvent<HTMLInputElement> | React.ChangeEvent<HTMLTextAreaElement>) {
      setData({
        ...data,
        [attr]: event.target.value
      })
    }
  }

  function toggleDivisionCheckbox(divisionId: number) {
    return function handleDivisionChange(event: React.FormEvent<HTMLInputElement>, checkbox: CheckboxProps) {

      const divisionIds = (function() {
        if(checkbox.checked) {
          return [...data.divisionIds, divisionId]
        } else {
          return data.divisionIds.filter(id => id !== divisionId)
        }
      })()

      setData({
        ...data,
        divisionIds
      })

    }
  }

  function handleSubmit() {
    onSubmit(data, setErrors)
  }

  return (
    <Form onSubmit={handleSubmit} loading={loading}>
      <Form.Input label="Name" onChange={bind('name')} error={errors['name']} value={data.name} />
      <Form.Field label="Starts On" onChange={(val: string) => { setData({...data, startsOn: val})}} format="YYYY-MM-DD" error={errors['startsOn']} value={data.startsOn} control={DateTimeInput} type="date" />
      {divisions.map(division => (
        <Form.Checkbox
          key={division.id}
          label={division.name}
          checked={!!(data.divisionIds || []).find(id => id === division.id)}
          onChange={toggleDivisionCheckbox(division.id)}
        />
      ))}
      <Form.Button type="submit">Submit</Form.Button>

    </Form>
  )
}

export default SeasonForm

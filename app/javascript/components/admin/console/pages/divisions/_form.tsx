import React, { FC, useState, useEffect } from 'react';
import { Form, CheckboxProps } from 'semantic-ui-react';
import { Division } from '../../actions/divisions';
import { Season, list } from '../../actions/seasons';
import { DateTimeInput } from '../../components/date-time-input'
import * as moment from 'moment';

interface P {
  data?: Partial<Division>
  seasons: Season[]
  loading?: boolean
  onSubmit: (data: Partial<Division>, setErrors: (errors: any) => void) => void
}

const DivisionForm: FC<P> = (props) => {
  const {
    onSubmit,
    loading = false,
    seasons = []
  } = props

  const [data, setData] = useState(props.data || {})
  const [errors, setErrors] = useState({})

  useEffect(() => {
    const {
      name = '',
      seasonIds = []
    } = props.data
    setData({ name, seasonIds })
  }, [props.data])

  function bind(attr: keyof Division) {
    return function(event: React.ChangeEvent<HTMLInputElement> | React.ChangeEvent<HTMLTextAreaElement>) {
      setData({
        ...data,
        [attr]: event.target.value
      })
    }
  }

  function toggleSeasonCheckbox(divisionId: number) {
    return function handleSeasonChange(event: React.FormEvent<HTMLInputElement>, checkbox: CheckboxProps) {

      const seasonIds = (function() {
        if(checkbox.checked) {
          return [...data.seasonIds, divisionId]
        } else {
          return data.seasonIds.filter(id => id !== divisionId)
        }
      })()

      setData({
        ...data,
        seasonIds
      })

    }
  }

  function handleSubmit() {
    onSubmit(data, setErrors)
  }

  return (
    <Form onSubmit={handleSubmit} loading={loading}>
      <Form.Input label="Name" onChange={bind('name')} error={errors['name']} value={data.name} />
      {/* <Form.Field label="Starts On" onChange={(val: string) => { setData({...data, startsOn: val})}} format="YYYY-MM-DD" error={errors['startsOn']} value={data.startsOn} control={DateTimeInput} type="date" /> */}
      {seasons.map(division => (
        <Form.Checkbox
          key={division.id}
          label={division.name}
          checked={!!(data.seasonIds || []).find(id => id === division.id)}
          onChange={toggleSeasonCheckbox(division.id)}
        />
      ))}
      <Form.Button type="submit">Submit</Form.Button>

    </Form>
  )
}

export default DivisionForm

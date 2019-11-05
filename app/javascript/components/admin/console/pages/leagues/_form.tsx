import React, { FC, useState, useEffect } from 'react';
import { Form } from 'semantic-ui-react';
import { League } from '../../actions/leagues';

interface P {
  data?: Partial<League>
  loading?: boolean
  onSubmit: (data: Partial<League>, setErrors: (errors: any) => void) => void
}

const LeagueForm: FC<P> = (props) => {
  const {
    onSubmit,
    loading = false
  } = props
  const [data, setData] = useState(props.data || {})
  const [errors, setErrors] = useState({})
  useEffect(() => {
    setData(props.data || {})
  }, [props.data])
  function bind(attr: keyof League) {
    return function(event: React.ChangeEvent<HTMLInputElement> | React.ChangeEvent<HTMLTextAreaElement>) {
      setData({
        ...data,
        [attr]: event.target.value
      })
    }
  }
  function handleSubmit() {
    onSubmit(data, setErrors)
  }
  return (
    <Form onSubmit={handleSubmit} loading={loading}>
      <Form.Input label="Name" onChange={bind('name')} error={errors['name']} value={data.name} />
      <Form.Input label="Short Name" onChange={bind('description')} error={errors['description']} value={data.description} />
      <Form.Button type="submit">Submit</Form.Button>
    </Form>
  )
}

export default LeagueForm

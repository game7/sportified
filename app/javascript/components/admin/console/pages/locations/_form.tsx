import React, { FC, useState, useEffect } from 'react';
import { Form } from 'semantic-ui-react';
import { Location } from '../../actions/locations';

interface LocationFormProps {
  data?: Partial<Location>
  loading?: boolean
  onSubmit: (data: Partial<Location>, setErrors: (errors: any) => void) => void
}

const LocationForm: FC<LocationFormProps> = (props) => {
  const {
    onSubmit,
    loading = false
  } = props
  const [data, setData] = useState(props.data || {})
  const [errors, setErrors] = useState({})
  useEffect(() => {
    setData(props.data || {})
  }, [props.data])
  function bind(attr: keyof Location) {
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
      <Form.Input label="Short Name" onChange={bind('shortName')} error={errors['shortName']} value={data.shortName} />
      <Form.Button type="submit">Submit</Form.Button>
    </Form>
  )
}

export default LocationForm

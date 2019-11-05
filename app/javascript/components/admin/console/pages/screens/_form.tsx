import React, { FC, useState, useEffect } from 'react';
import { Form, DropdownProps } from 'semantic-ui-react';
import { Screen } from '../../actions/screens';
import { Location, list as listLocations } from '../../actions/locations';

interface ScreenFormProps {
  data?: Partial<Screen>
  loading?: boolean
  onSubmit: (data: Partial<Screen>, setErrors: (errors: any) => void) => void
}

const ScreenForm: FC<ScreenFormProps> = (props) => {
  const {
    onSubmit,
    loading
  } = props

  const [data, setData] = useState(props.data || {})
  const [locations, setLocations] = useState<Location[]>([])
  const [errors, setErrors] = useState({})

  useEffect(() => {
    (async () => {
      setData(data)
    })()
  }, [])

  useEffect(() => {
    (async () => {
      setLocations(await listLocations({}))
    })()
  }, [])

  const locationOptions = locations.map(l => ({ value: l.id, text: l.name }))

  function bind(attr: keyof Screen) {
    return function(event: React.ChangeEvent<HTMLInputElement> | React.ChangeEvent<HTMLTextAreaElement>) {
      setData({
        ...data,
        [attr]: event.target.value
      })
    }
  }

  function handleLocationChange(_event, props: DropdownProps) {
    setData({
      ...data,
      locationId: (props.value as number)
    })
  }

  function handleSubmit() {
    onSubmit(data, setErrors)
  }
  console.log('data: ', data, locationOptions)
  return (
    <Form onSubmit={handleSubmit} loading={loading}>
      <Form.Input label="Name" onChange={bind('name')} error={errors['name']} value={data.name} />
      <Form.Select label="Location" onChange={handleLocationChange} error={errors['locationId']} value={data.locationId} options={locationOptions} />
      <Form.Button type="submit">Submit</Form.Button>
    </Form>
  )
}

export default ScreenForm

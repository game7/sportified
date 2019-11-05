import React, { FC, useEffect, useState } from 'react';
import Layout from '../../components/layout'
import { Location, find, update } from '../../actions/locations'
import { RouteComponentProps } from 'react-router-dom'
import Form from './_form'

export const LocationsUpdate: FC<RouteComponentProps<{ id: number }>> = ({ match, history }) => {
  const {
    id
  } = match.params
  const [loading, setLoading] = useState(false)
  const [location, setLocation] = useState<Partial<Location>>({ name: "", shortName: ""})
  useEffect(() => {
    (async function load() {
      setLoading(true);
      setLocation(await find({ id }))
      setLoading(false);
    })()
  }, [])
  async function handleSubmit(attributes: Partial<Location>, setErrors) {
    setLoading(true)
    try {
      await update({ id, attributes })
      history.push('/locations')
    }
    catch(errors) {
      setErrors(errors)
    }
    setLoading(false)
  }
  return (
    <Layout title="Edit Location">
      <Form data={location} onSubmit={handleSubmit} loading={loading} />
    </Layout>
  )
}

export default LocationsUpdate;


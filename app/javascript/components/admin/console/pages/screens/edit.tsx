import React, { FC, useEffect, useState } from 'react';
import Layout from '../../components/layout'
import { Screen, find, update } from '../../actions/screens'
import { RouteComponentProps } from 'react-router-dom'
import Form from './_form'
import { pluck } from '../../utils'

export const ScreensUpdate: FC<RouteComponentProps<{ id: number }>> = ({ match, history }) => {
  const {
    id
  } = match.params
  const [loading, setLoading] = useState(false)
  const [screen, setScreen] = useState<Partial<Screen>>()
  const [locations, setLocations] = useState<Location[]>([])
  useEffect(() => {
    (async function load() {
      setLoading(true);
      setScreen(pluck(await find({ id }), "name", "locationId"))
      setLoading(false);
    })()
  }, [])
  async function handleSubmit(attributes: Partial<Screen>, setErrors) {
    setLoading(true)
    try {
      await update({ id, attributes })
      history.push('/screens')
    }
    catch(errors) {
      setErrors(errors)
    }
    setLoading(false)
  }
  return (
    <Layout title="Edit Screen">
      {screen && (
        <Form data={screen} onSubmit={handleSubmit} loading={loading} />
      )}
    </Layout>
  )
}

export default ScreensUpdate;


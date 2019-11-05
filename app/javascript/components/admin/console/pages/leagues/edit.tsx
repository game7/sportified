import React, { FC, useEffect, useState } from 'react';
import Layout from '../../components/layout'
import { League, find, update } from '../../actions/leagues'
import { RouteComponentProps } from 'react-router-dom'
import Form from './_form'

export const LeaguesUpdate: FC<RouteComponentProps<{ id: number }>> = ({ match, history }) => {
  const {
    id
  } = match.params
  const [loading, setLoading] = useState(false)
  const [league, setLeague] = useState<Partial<League>>({ name: "", description: ""})
  useEffect(() => {
    setLoading(true);
    find({ id }).then(setLeague).then(() => { setLoading(false) })
  }, [])
  function handleSubmit(attributes: Partial<League>, setErrors) {
    update({ id, attributes }).then(() => {
      history.push('/leagues')
    }).catch(errors => {
      setErrors(errors)
    }).then(() => setLoading(false))
  }
  return (
    <Layout title="Edit League">
      <Form data={league} onSubmit={handleSubmit} loading={loading} />
    </Layout>
  )
}

export default LeaguesUpdate;


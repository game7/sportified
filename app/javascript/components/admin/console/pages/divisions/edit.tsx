import React, { FC, useEffect, useState } from 'react';
import Layout from '../../components/layout'
import { Division, find, update } from '../../actions/divisions'
import { Season, list as listSeasons } from '../../actions/seasons'
import { RouteComponentProps } from 'react-router-dom'
import Form from './_form'

export const DivisionsUpdate: FC<RouteComponentProps<{ id: number }>> = ({ match, history }) => {
  const {
    id
  } = match.params
  const [loading, setLoading] = useState(false)
  const [division, setDivision] = useState<Partial<Division>>({ name: "" })
  const [seasons, setSeasons] = useState<Season[]>([])

  useEffect(function() {
    (async function load() {
      setLoading(true)
      const division = await find({ id })
      setDivision(division)
      const seasons = await listSeasons({ leagueId: division.programId })
      setSeasons(seasons)
      setLoading(false)
    })()
  }, [])

  function handleSubmit(attributes: Partial<Division>, setErrors) {
    update({ id, attributes }).then(() => {
      history.push(`/leagues/${division.programId}/divisions/${division.id}`)
    }).catch(errors => {
      setErrors(errors)
    }).then(() => setLoading(false))
  }

  return (
    <Layout title="Edit Division">
      <Form data={division} onSubmit={handleSubmit} loading={loading} seasons={seasons} />
    </Layout>
  )
}

export default DivisionsUpdate;


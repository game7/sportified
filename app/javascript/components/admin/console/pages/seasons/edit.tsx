import React, { FC, useEffect, useState } from 'react';
import Layout from '../../components/layout'
import { Season, find, update } from '../../actions/seasons'
import { Division, list as listDivisions } from '../../actions/divisions'
import { RouteComponentProps } from 'react-router-dom'
import Form from './_form'

export const SeasonsUpdate: FC<RouteComponentProps<{ id: number }>> = ({ match, history }) => {
  const {
    id
  } = match.params
  const [loading, setLoading] = useState(false)
  const [season, setSeason] = useState<Partial<Season>>({ name: "", startsOn: "" })
  const [divisions, setDivisions] = useState<Division[]>([])
  useEffect(function() {
    (async function load() {
      setLoading(true)
      const season = await find({ id });
      setSeason(season)
      const divisions = await listDivisions({ leagueId: season.programId })
      setDivisions(divisions)
      setLoading(false)
    })()
  }, [])
  function handleSubmit(attributes: Partial<Season>, setErrors) {
    update({ id, attributes }).then(() => {
      history.push(`/leagues/${season.programId}/seasons/${season.id}`)
    }).catch(errors => {
      setErrors(errors)
    }).then(() => setLoading(false))
  }
  return (
    <Layout title="Edit Season">
      <Form data={season} onSubmit={handleSubmit} loading={loading} divisions={divisions} />
    </Layout>
  )
}

export default SeasonsUpdate;


import React, { FC, useEffect, useState, useCallback, useRef } from 'react';
import Layout from '../../components/layout'
import { Team, find, update } from '../../actions/teams'
import { RouteComponentProps } from 'react-router-dom'
import Form from './_form'
import { previous, pluck } from '../../utils'

const ATTRS: Array<keyof Team> =  ["name", "shortName", "showInStandings", "primaryColor", "secondaryColor", "accentColor"]

interface Loader {
  loading: boolean
  loaded: boolean
}

export const TeamsUpdate: FC<RouteComponentProps<{ id: number }>> = ({ match, history }) => {
  const {
    id
  } = match.params
  const [loader, setLoader] = useState<Loader>({ loading: false, loaded: false })
  const [team, setTeam] = useState<Team>(null)
  const [data, setData] = useState<Partial<Team>>(null)

  useEffect(() => {
    (async function load() {
      setLoader({ ...loader, loading: true })
      const team = await find({id});
      setTeam(team)
      setData(pluck(team, ...ATTRS))
      setLoader({ loading: false, loaded: true });
    })()
  }, [])

  async function handleSubmit(attributes: Partial<Team>, setErrors) {
    setLoader({ ...loader, loading: true })
    try {
      await update({ id, attributes })
      history.push(previous.location())
    }
    catch(errors) {
      setErrors(errors)
    }
    setLoader({ ...loader, loading: false })
  }

  async function handleChange(data: Partial<Team>) {
    setData(data)
  }

  return (
    <Layout title="Edit Team">
      {loader.loaded && data && (
        <Form data={data} avatarUrl={team.avatarUrl} onSubmit={handleSubmit} onChange={handleChange} />
      )}
    </Layout>
  )
}

export default TeamsUpdate;


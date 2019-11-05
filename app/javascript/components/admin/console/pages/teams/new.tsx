import React, { FC, useState } from 'react';
import Layout from '../../components/layout'
import { Team, create } from '../../actions/teams'
import { RouteComponentProps } from 'react-router-dom'
import Form from './_form';


export const TeamsNew: FC<RouteComponentProps<{}>> = ({ history }) => {

  async function handleSubmit(data: Partial<Team>, setErrors) {
    try {
      await create({ attributes: data })
      history.push('/teams')
    }
    catch(errors) {
      setErrors(errors)
    }
  }

  return (
    <Layout title="New Team">
      <Form onSubmit={handleSubmit} />
    </Layout>
  )
}

export default TeamsNew;

import React, { FC, useState } from 'react';
import Layout from '../../components/layout'
import { League, create } from '../../actions/leagues'
import { RouteComponentProps } from 'react-router-dom'
import Form from './_form';


export const LeaguesNew: FC<RouteComponentProps<{}>> = ({ history }) => {

  function handleSubmit(data: Partial<League>, setErrors) {
    create({ attributes: data }).then(() => {
      history.push('/leagues')
    }).catch(errors => {
      setErrors(errors)
    })
  }
  return (
    <Layout title="New League">
      <Form onSubmit={handleSubmit} data={{ name: '', description: ''}} />
    </Layout>
  )
}

export default LeaguesNew;

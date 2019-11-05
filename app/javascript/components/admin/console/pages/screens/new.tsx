import React, { FC, useState, useEffect } from 'react';
import Layout from '../../components/layout'
import { Screen, create } from '../../actions/screens'
import { RouteComponentProps } from 'react-router-dom'
import Form from './_form';


export const ScreensNew: FC<RouteComponentProps<{}>> = ({ history }) => {

  function handleSubmit(data: Partial<Screen>, setErrors) {
    create({ attributes: data }).then(() => {
      history.push('/screens')
    }).catch(errors => {
      setErrors(errors)
    })
  }
  return (
    <Layout title="New Screen">
      <Form onSubmit={handleSubmit} />
    </Layout>
  )
}

export default ScreensNew;

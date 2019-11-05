import React, { FC, useState } from 'react';
import Layout from '../../components/layout'
import { Location, create } from '../../actions/locations'
import { RouteComponentProps } from 'react-router-dom'
import Form from './_form';


export const LocationsNew: FC<RouteComponentProps<{}>> = ({ history }) => {

  function handleSubmit(data: Partial<Location>, setErrors) {
    create({ attributes: data }).then(() => {
      history.push('/locations')
    }).catch(errors => {
      setErrors(errors)
    })
  }
  return (
    <Layout title="New Location">
      <Form onSubmit={handleSubmit} />
    </Layout>
  )
}

export default LocationsNew;

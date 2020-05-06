import React from 'react'
import { Form } from 'semantic-ui-react'

interface Props {

}

export const Registration: (Props) => React.ReactElement = (props) => {

  const profiles = []

  return (
    <React.Fragment>
      <Form>
        <Form.Input label="Email" width="six" />
        <Form.Group widths="four">
          <Form.Input label="First Name" />
          <Form.Input label="Last Name" />
          <Form.Input label="Date of Birth" type="date" />
        </Form.Group>
      </Form>
    </React.Fragment>
  )
}

export default Registration;
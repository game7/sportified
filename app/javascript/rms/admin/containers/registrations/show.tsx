import * as React from 'react';
import { RouteComponentProps, Route, Link } from 'react-router-dom';
import { Registration } from '../../data';

interface Props extends RouteComponentProps<{ id: number }> {

}

interface State {
  registration: Registration
}

export default class RegistrationsShow extends React.Component<Props,State> {

  componentWillMount() {
    this.setState({ registration: null }, () => {
      fetch(`/registrar/api/registrations/${this.props.match.params.id}`)
        .then(response => response.json())
        .then<Registration>(payload => payload as Registration)
        .then(registration => {
          this.setState({ registration })
        });
    });
  }

  render() {
    const { registration } = this.state;
    if (!registration) return <div/>
    return (
      <div>
        <h1>Registration</h1>
        <hr/>
        <dl>
          <dt>ID</dt>
          <dd>{registration.id}</dd>
          <dt>Name</dt>
          <dd>{registration.firstName} {registration.lastName}</dd>
          <dt>Variant</dt>
          <dd>{registration['variant']['title']}</dd>
          <dt>Price</dt>
          <dd>{registration.price}</dd>
          <dt>Status</dt>
          <dd>{registration.status}</dd>
        </dl>
      </div>
    );
  }
}

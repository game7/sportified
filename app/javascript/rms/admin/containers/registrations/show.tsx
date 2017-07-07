import * as React from 'react';
import { RouteComponentProps, Route, Link } from 'react-router-dom';
import { Table } from 'semantic-ui-react';
import { Registration } from '../../data';
import { Format } from '../../utils';

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

  renderForm(form) {
    const { data } = form;
    const keys = Object.keys(data);
    return (
      <Table definition>
        <Table.Body>
          {keys.map(key => (
            <Row
              title={Format.titleize(key)}
              data={data[key]}
            />
          ))}
        </Table.Body>
      </Table>
    );
  }

  render() {
    const { registration } = this.state;
    if (!registration) return <div/>
    return (
      <div>
        <h1>Registration</h1>
        <hr/>
        <Table definition>
          <Table.Body>
            <Row title='ID' data={registration.id}/>
            <Row title='Name' data={`${registration.firstName} ${registration.lastName}`}/>
            <Row title='Item' data={registration['item']['title']}/>
            <Row title='Variant' data={registration['variant']['title']}/>
            <Row title='Price' data={Format.dollars(registration.price)}/>
            <Row title='Status' data={registration.status}/>
            <Row title='Updated At' data={Format.timeAgo(registration.updatedAt)}/>
          </Table.Body>
        </Table>
        {registration['forms'].map(this.renderForm)}
        <hr/>
      </div>
    );
  }
}

const Row = ({title, data} : { title: string, data: any }) => (
  <Table.Row>
    <Table.Cell width={4} content={title}/>
    <Table.Cell width={12} content={data}/>
  </Table.Row>
)

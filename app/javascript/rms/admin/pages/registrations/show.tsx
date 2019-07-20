import React, { FC, useState, useEffect } from 'react';
import { RouteComponentProps, Route, Link } from 'react-router-dom';
import { Table } from 'semantic-ui-react';
import { Registration } from '../../data';
import { Form } from '../../data/form';
import { Format } from '../../utils';

interface Props extends RouteComponentProps<{ id: number }> {}

const RegistrationsShow : FC<Props> = ({ match }) => {

  const [registration, setRegistration] = useState<Registration>()

  useEffect(() => {
    fetch(`/registrar/api/registrations/${match.params.id}`)
      .then(response => response.json())
      .then<Registration>(payload => payload as Registration)
      .then(registration => {
        setRegistration(registration)
      });
  }, []);

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
      {registration.forms.map(form => <Form key={form.id} form={form} />)}
    </div>
  );

}

export default RegistrationsShow;

const Form: FC<{ form: Form}> = ({ form }) => {
  const { data } = form;
  if(!data) return (<div/>)
  const keys = Object.keys(data);
  return (
    <Table definition key={form.id}>
      <Table.Body>
        {keys.map(key => (
          <Row
            key={key}
            title={Format.titleize(key)}
            data={data[key]}
          />
        ))}
      </Table.Body>
    </Table>
  );
}

const Row: FC<{ title: string, data: any}> = ({title, data}) => (
  <Table.Row>
    <Table.Cell width={4} content={title}/>
    <Table.Cell width={12} content={data}/>
  </Table.Row>
)

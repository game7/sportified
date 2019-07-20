import React, { FC, useState, useEffect } from 'react';
import { RouteComponentProps, Route, Link } from 'react-router-dom';
import { Menu } from 'semantic-ui-react';
import { Item } from '../../data';

import Dashboard from './dashboard';
import Registrations from './registrations';

interface Props extends RouteComponentProps<{id: number}> {

}


const Index : FC<Props> = ({ match: { params: { id }, url } }) => {

  const [item, setItem] = useState<Item>();

  useEffect(() => {
    fetch(`/registrar/api/items/${id}`)
      .then(response => response.json())
      .then<Item>(payload => payload.item)
      .then(item => { setItem(item) });
  }, [])

  if (!item) return (<div/>);

  return (
    <div>
      <h2>{item.title}</h2>
      <Route
        exact
        path={`${url}/`}
        render={(props) => (
          <div>
            <Menu>
              <Menu.Item
                as={Link}
                to={`/items/${item.id}`}
                active={true}
                content="Dashboard"
              />
              <Menu.Item
                as={Link}
                to={`/items/${item.id}/registrations`}
                active={props.match.url == `/items/${item.id}/registrations`}
                content="Registrations"
              />
            </Menu>
            <Dashboard {...props} item={item} />
          </div>
        )}/>
      <Route
        path={`${url}/registrations`}
        render={(props) => (
          <div>
          <Menu>
            <Menu.Item
              as={Link}
              to={`/items/${item.id}`}
              content="Dashboard"
            />
            <Menu.Item
              as={Link}
              to={`/items/${item.id}/registrations`}
              active={true}
              content="Registrations"
            />
          </Menu>
          <Registrations {...props} item={item} />
          </div>
        )}/>
    </div>
  )

}

export default Index

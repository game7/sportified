import * as React from 'react';
import { Link } from 'react-router-dom';
import { Menu, Container } from 'semantic-ui-react';

export default (props: { location: string }) => (
  <Menu>
    <Container>
      <Menu.Item header>Registrar</Menu.Item>
      <Menu.Item as={Link} to='/' active={props.location == "/"}>Home</Menu.Item>
      <Menu.Item as={Link} to='/items' active={props.location.indexOf('/items') == 0}>Items</Menu.Item>
    </Container>
  </Menu>
)

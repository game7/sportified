import * as React from 'react';
import { Link } from 'react-router-dom';
import { Menu, Container } from 'semantic-ui-react';

export default () => (
  <Menu>
    <Container>
      <Menu.Item header>Registrar</Menu.Item>
      <Menu.Item as={Link} to='/'>Home</Menu.Item>
      <Menu.Item as={Link} to='/items'>Items</Menu.Item>
    </Container>
  </Menu>
)

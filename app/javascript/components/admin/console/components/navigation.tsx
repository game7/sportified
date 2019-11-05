import React, { useState } from 'react'
import 'semantic-ui-css/semantic.css'
import { Link } from 'react-router-dom';
import { Menu, Container, Sidebar, Segment, Icon, Header, Image } from 'semantic-ui-react'

export const Navigation: React.FC<{}> = () => {
  return (
    <Menu
      icon='labeled'
      vertical
      width='thin'
    >
      <Menu.Item as={Link} to='/'>
        <Icon name='home' />
        Home
      </Menu.Item>
      <Menu.Item as={Link} to="/calendar">
        <Icon name='calendar' />
        Calendar
      </Menu.Item>
      <Menu.Item as={Link} to="/games">
        <Icon name='calendar check' />
        Games
      </Menu.Item>
      <Menu.Item as={Link} to="/leagues">
        <Icon name='trophy' />
        Leagues
      </Menu.Item>
      <Menu.Item as={Link} to='/pages'>
        <Icon name='file alternate' />
        Pages
      </Menu.Item>
      <Menu.Item as={Link} to='/posts'>
        <Icon name='sticky note' />
        Posts
      </Menu.Item>
      <Menu.Item as={Link} to="/people">
        <Icon name='user' />
        People
      </Menu.Item>
      <Menu.Item as={Link} to='/locations'>
        <Icon name='map marker' />
        Locations
      </Menu.Item>
      <Menu.Item as={Link} to='/screens'>
        <Icon name='tv' />
        Screens
      </Menu.Item>
      <Menu.Item as='a'>
        <Icon name='upload' />
        Upload
      </Menu.Item>
    </Menu>
  )
}

export default Navigation;

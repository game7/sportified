import * as React from 'react'
import * as ReactDOM from 'react-dom'
import { Menu, Sidebar } from 'semantic-ui-react'

interface Props {
  expanded: boolean
}

export const NavMenu = (props: Props) => {
  const { expanded } = props
  return (
    <Sidebar
      as={Menu}
      animation='push'
      visible={expanded}
      vertical
      inverted
    >
      <Menu.Item name="about">
        <Menu.Header>About</Menu.Header>
        <Menu.Menu>
          <Menu.Item>
            Arena Info
          </Menu.Item>
          <Menu.Item>
            Advertising
          </Menu.Item>
          <Menu.Item>
            Employment
          </Menu.Item>
          <Menu.Item>
            Contacts
          </Menu.Item>
        </Menu.Menu>
      </Menu.Item>

      <Menu.Item name="activities">
        <Menu.Header>Activities</Menu.Header>
        <Menu.Menu>
          <Menu.Item>
            Public Skating
          </Menu.Item>
          <Menu.Item>
            Figure Skating
          </Menu.Item>
          <Menu.Item>
            Ice Rental
          </Menu.Item>
        </Menu.Menu>
      </Menu.Item>

      <Menu.Item name="hockey">
        <Menu.Header>Adult Hockey</Menu.Header>
        <Menu.Menu>
          <Menu.Item>
            Leagues
          </Menu.Item>
          <Menu.Item>
            Adult Hockey Skills
          </Menu.Item>
          <Menu.Item>
            Open Hockey & Stick Time
          </Menu.Item>
        </Menu.Menu>
      </Menu.Item>

      <Menu.Item>
        <Menu.Header>College Hockey</Menu.Header>
        <Menu.Menu>
          <Menu.Item>
            NCAA
          </Menu.Item>
          <Menu.Item>
            ACHA
          </Menu.Item>
        </Menu.Menu>
      </Menu.Item>

      <Menu.Item>
        <Menu.Header>Youth Hockey</Menu.Header>
        <Menu.Menu>
          <Menu.Item>
            Overview
          </Menu.Item>
          <Menu.Item>
            Skate & Surf
          </Menu.Item>
        </Menu.Menu>
      </Menu.Item>
    </Sidebar>
  )
}

export default NavMenu

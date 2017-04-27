import * as React from 'react'
import * as ReactDOM from 'react-dom'
import { Menu, Sidebar, Icon } from 'semantic-ui-react'

interface Props {
  expanded: boolean
}

export const AccountMenu = (props: Props) => {
  const { expanded } = props
  return (
    <Sidebar
      as={Menu}
      animation='push'
      visible={expanded}
      direction="right"
      icon="labeled"
      width="thin"
      vertical
      inverted
    >
      <Menu.Item>
        <Icon name="user"/>
        Profile
      </Menu.Item>
      <Menu.Item>
        <Icon name="calendar"/>
        Schedule
      </Menu.Item>
      <Menu.Item>
        <Icon name="group"/>
        Teams
      </Menu.Item>
      <Menu.Item>
        <Icon name="signup"/>
        Registrations
      </Menu.Item>
      <Menu.Item>
        <div>
        <Icon.Group size="big">
          <Icon name='inbox' />
          <Icon corner color="yellow" name='warning circle' />
        </Icon.Group>
        </div>
        Messages
      </Menu.Item>
      <Menu.Item>
        <Icon name="log out"/>
        Sign Out
      </Menu.Item>
    </Sidebar>
  )
}

export default AccountMenu

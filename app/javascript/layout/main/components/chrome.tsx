import * as React from 'react'
import * as ReactDOM from 'react-dom'
import { Container, Icon, Menu } from 'semantic-ui-react'

interface Props {
  onToggleNavMenu: () => void
  onToggleAccountMenu: () => void
  navActive: boolean
  accountActive: boolean
}

export const Chrome = (props: Props) => {
  const {
    onToggleAccountMenu,
    onToggleNavMenu,
    navActive,
    accountActive
  } = props
  return (
    <Menu inverted style={{ backgroundColor: "maroon", borderRadius: 0 }}>
      <Container>
        <Menu.Item active={navActive} onClick={onToggleNavMenu}>
          <Icon name="bars"/> Menu
        </Menu.Item>
        <Menu.Item style={{ flexGrow: 5 }}>
          <Menu.Header as="h4" style={{ width: '100%', textAlign: 'center' }}>Oceanside Ice Arena</Menu.Header>
        </Menu.Item>
        <Menu.Item active={accountActive} onClick={onToggleAccountMenu}>
         <Icon name="user"/> Account
        </Menu.Item>
      </Container>
    </Menu>
  )
}

export default Chrome

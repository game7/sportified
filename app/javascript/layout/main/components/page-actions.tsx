import * as React from 'react'
import { Dropdown, Icon } from 'semantic-ui-react'

export const PageActions = () => {
  return (
    <div style={{float: 'right'}}>
      <Dropdown button floating icon='settings'>
        <Dropdown.Menu style={{ right: 0, left: 'auto' }}>
          <Dropdown.Item><Icon name="setting"/> Edit Settings</Dropdown.Item>
          <Dropdown.Item><Icon name="image"/> Set Header Image</Dropdown.Item>
        </Dropdown.Menu>
      </Dropdown>
    </div>
  )
}

export default PageActions

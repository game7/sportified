import React, { FC, useState } from 'react'
import { Dropdown } from 'semantic-ui-react'

export const ActionsDropdown: FC<{}> = ({ children }) => {
  const [open, setOpen] = useState(false)
  const orientation = open ? 'vertical' : 'horizontal'
  return (
    <Dropdown icon={`ellipsis ${orientation}`} onOpen={() => setOpen(true)} onClose={() => setOpen(false)}>
      <Dropdown.Menu direction="left">
        {children}
      </Dropdown.Menu>
    </Dropdown>
  )
}

export default ActionsDropdown

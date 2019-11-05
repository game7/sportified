import React, { FC } from 'react'
import { Card, Icon, Form } from 'semantic-ui-react'
import { Block, ContactBlock } from '../../actions/pages'

export const Contact: FC<{ block: Block }> = (props) => {
  const block = props.block as ContactBlock
  const { options } = block;
  const fullname = options.first + ' ' + options.last
  return (
    <Card>
      <Card.Content>
        <Card.Header content={fullname} />
        {options.title && (<Card.Meta content={options.title}/>)}
      </Card.Content>
      {options.email && (
        <Card.Content>
          <Icon name='mail' />
          {options.email}
        </Card.Content>
      )}
      {options.phone && (
        <Card.Content>
          <Icon name='phone' />
          {options.phone}
        </Card.Content>
      )}
    </Card>
  )
}

interface ContactBlockPanelProps {
  block: Block
  onChange: (block: Block) => void
}

export const ContactBlockPanel: FC<ContactBlockPanelProps> = (props) => {
  const block = props.block as ContactBlock
  const { options } = block;
  function bind(model: typeof block.options, attr: keyof typeof block.options) {
    return function(event: React.ChangeEvent<HTMLInputElement> | React.ChangeEvent<HTMLTextAreaElement>) {
      props.onChange({
        ...block,
        options: {
          ...block.options,
          [attr]: event.target.value
        }
      })
    }
  }
  return (
    <Form>
      <Form.Input label="First Name" value={options.first} onChange={bind(options, "first")} />
      <Form.Input label="Last Name" value={options.last} onChange={bind(options, "last")} />
      <Form.Input label="Email" value={options.email}  onChange={bind(options, "email")} />
      <Form.Input label="Phone" value={options.phone}  onChange={bind(options, "phone")} />
    </Form>
  )
}

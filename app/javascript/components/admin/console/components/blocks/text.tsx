import React, { FC } from 'react'
import { Header, Form } from 'semantic-ui-react'
import { Block, TextBlock } from '../../actions/pages'

export const Text: FC<{ block: Block }> = (props) => {
  const block = props.block as TextBlock
  const {
    options
  } = block
  return (
    <div>
      {options.title && (
        <Header as="h2" content={options.title}/>
      )}
      <div dangerouslySetInnerHTML={{ __html: options.render }} />
    </div>
  )
}

interface TextBlockPanelProps {
  block: Block
  onChange: (block: Block) => void
}

export const TextBlockPanel: FC<TextBlockPanelProps> = (props) => {
  const block = props.block as TextBlock
  const { options } = block;
  function bind(model: typeof block.options, attr: keyof typeof block.options) {
    return function(event: React.ChangeEvent<HTMLInputElement> | React.FormEvent<HTMLTextAreaElement>) {
      props.onChange({
        ...block,
        options: {
          ...block.options,
          [attr]: event.target['value']
        }
      })
    }
  }
  return (
    <Form>
      <Form.Input label="title" value={options.title} onChange={bind(options, "title")} />
      <Form.TextArea label="Body" value={options.body} onChange={bind(options, "body")} rows="20" />
    </Form>
  )
}

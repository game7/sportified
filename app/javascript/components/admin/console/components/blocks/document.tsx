import React, { FC } from 'react'
import { Icon, Form, Segment, Header, Button } from 'semantic-ui-react'
import { Block, DocumentBlock } from '../../actions/pages'

export const Document: FC<{ block: Block }> = (props) => {
  const block = props.block as DocumentBlock
  // const { options } = block;

  return (
    <Segment secondary textAlign="center">
      <Icon name="file outline"/>
      <p>
        Upload a file.
      </p>
      <Button size="tiny">Upload</Button>
    </Segment>
  )
}

interface DocumentBlockPanelProps {
  block: Block
  onChange: (block: Block) => void
}

export const DocumentBlockPanel: FC<DocumentBlockPanelProps> = (props) => {
  const block = props.block as DocumentBlock
  // const { options } = block;
  // function bind(model: typeof block.options, attr: keyof typeof block.options) {
  //   return function(event: React.ChangeEvent<HTMLInputElement> | React.ChangeEvent<HTMLTextAreaElement>) {
  //     props.onChange({
  //       ...block,
  //       options: {
  //         ...block.options,
  //         [attr]: event.target.value
  //       }
  //     })
  //   }
  // }
  return (
    <Form>

    </Form>
  )
}

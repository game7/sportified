import React, { FC } from 'react'
import { Block, MarkupBlock } from '../../actions/pages'

export const Markup: FC<{ block: Block }> = (props) => {
  const block = props.block as MarkupBlock
  return (
    <div dangerouslySetInnerHTML={{ __html: block.options.body }}></div>
  )
}


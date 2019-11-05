import React, { FC, useState, CSSProperties } from 'react'
import { Button } from 'semantic-ui-react'
import { Block } from '../../actions/pages'
import { Contact, ContactBlockPanel } from './contact'
import { Markup } from './markup'
import { Text, TextBlockPanel } from './text'
import { Document, DocumentBlockPanel } from './document'

const blocks = {
  markup: Markup,
  text: Text,
  contact: Contact,
  document: Document
}

const panels = {
  markup: Markup,
  text: TextBlockPanel,
  contact: ContactBlockPanel,
  document: DocumentBlockPanel
}

interface BlockProps {
  block: Block
  isFirst: boolean
  isLast: boolean
  onClick: (block: Block) => void
  onMoveUp: (block: Block) => void
  onMoveDown: (block: Block) => void
  selected: boolean
}

export const BlockComponent: FC<BlockProps> = ({ block, isFirst, isLast, onClick, selected, onMoveUp, onMoveDown }) => {
  const [hover, setHover] = useState(false)
  const type = block.type.replace("Blocks::", "").toLowerCase();
  const component = blocks[type] || NotFound
  let style: CSSProperties = {
    position: 'relative'
  }
  if(selected || hover) {
    style = {
      ...style,
      border: '1px dashed #CCC',
      padding: 5,
      margin: -6
    }
  }
  if(hover) {
    style = {
      ...style,
      cursor: 'pointer'
    }
  }
  return (
    <div style={{ marginBottom: 10 }}>
      <div onMouseEnter={() => { setHover(true) }} onMouseLeave={() => { setHover(false) }} style={style}>
        { (selected) && (
          <BlockMoveButtons
            canMoveUp={!isFirst}
            canMoveDown={!isLast}
            moveUp={() => { onMoveUp(block) }}
            moveDown={() => { onMoveDown(block) }}
          />
        )}
        { hover && (
          <div style={{ position: 'absolute', left: 0, top: -22, backgroundColor:'#CCC', color: '#FFF', paddingLeft: 5, paddingRight: 5 }}>
            <small>{type}</small>
          </div>
        )}
        <div onClick={() => { onClick(block) }}>
          {React.createElement(component, { block })}
        </div>
      </div>
    </div>
  )
}

const NotFound: FC<{ block: Block }> = ({ block }) => {
  return (
    <div>No Block component for {block.type}</div>
  )
}

interface BlockMoveButtonProps {
  canMoveUp: boolean
  canMoveDown: boolean
  moveUp?: () => void
  moveDown?: () => void
}

const BlockMoveButtons: FC<BlockMoveButtonProps> = (props) => {
  const {
    canMoveUp,
    canMoveDown,
    moveUp,
    moveDown
  } = props
  return (
    <Button.Group vertical basic size="mini" style={{ position: 'absolute', top: 0, left: '-40px' }}>
      <Button icon="chevron up" disabled={!canMoveUp} onClick={moveUp} />
      <Button icon="chevron down" disabled={!canMoveDown} onClick={moveDown} />
    </Button.Group>
  )
}

interface BlockPanelProps {
  block: Block
  onChange: (block: Block) => void
}

export const BlockPanel: FC<BlockPanelProps> = ({ block, onChange }) => {
  const type = block.type.replace("Blocks::", "").toLowerCase();
  const component = panels[type] || NotFound
  return (
    <React.Fragment>
      {React.createElement(component, { block, onChange })}
    </React.Fragment>
  )
}

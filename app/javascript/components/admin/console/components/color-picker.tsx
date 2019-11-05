import React, { FC, useState } from 'react';
import { Popup, Button, Label, Input, Table } from 'semantic-ui-react'
import { group, n, getTextColor } from '../utils'

interface ColorPickerProps {
  value: string;
  palette: string[];
  onChange: (color: string) => void;
}

const ColorPicker: FC<ColorPickerProps> = (props) => {
  const value = (props.value || '').replace(/#/g, "");
  const { palette, onChange, children } = props;
  const textColor = getTextColor(props.value)

  const trigger = (
    <Button onClick={(e) => { e.preventDefault() }} style={{ backgroundColor: props.value, color: textColor }}>
      {children}
    </Button>
  )

  function handleChange(e: React.ChangeEvent<HTMLInputElement>) {
    const value = e.target.value
    onChange(value.replace(/#/g, ""))
  }

  function handleClick(color) {
    onChange(color)
  }

  return (
    <Popup trigger={trigger} on="click" style={{ width: 165 }}>
      {palette.some(() => true) && (
        <Table>
          <Table.Body>
            {group(palette).by(4).map((group, i) => (
              <Table.Row key={i} width={4}>
                {group.items.map((color) => (
                  <Table.Cell key={color} textAlign="center" selectable style={{ cursor: 'pointer' }} onClick={(e) => handleClick(color)}>
                    <Label circular style={{ backgroundColor: color }}/>
                  </Table.Cell>
                ))}
                {n(group.blanks).times((i) => (
                  <Table.Cell key={i} content=""/>
                ))}
              </Table.Row>
            ))}
          </Table.Body>
        </Table>
      )}
      <Input label="#" value={value} style={{ width: 100 }} onChange={handleChange}></Input>
    </Popup>
  )
}

export default ColorPicker;

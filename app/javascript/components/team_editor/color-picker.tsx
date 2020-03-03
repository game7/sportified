import React, { FC, useState } from 'react';
import { Popup, Button, Label, Input, Table } from 'semantic-ui-react'
import { chunk, times } from 'lodash';

interface ColorPickerProps {
  value: string;
  palette: string[];
  onChange: (color: string) => void;
}

export const ColorPicker: FC<ColorPickerProps> = (props) => {
  const value = (props.value || '').replace(/#/g, "");
  const { palette, onChange, children } = props;
  const textColor = getTextColor(props.value)

  const trigger = (
    <Button onClick={(e) => { e.preventDefault() }} style={{ backgroundColor: props.value, color: textColor }}>
      {children}
    </Button>
  )

  function getTextColor(backgroundHexColor: string, dark = '#000000', light = '#ffffff') {
    if(!backgroundHexColor) { return dark }
    const parts = /^#?([A-Fa-f\d]{2})([A-Fa-f\d]{2})([A-Fa-f\d]{2})/i.exec(backgroundHexColor);
    if(!parts) { return dark }
    if(parts.length !== 4) { return dark }
    const r = parseInt(parts[1], 16);
    const g = parseInt(parts[2], 16);
    const b = parseInt(parts[3], 16);
    const a = 1 - (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return (a < 0.5) ? dark : light;
  }

  function handleChange(e: React.ChangeEvent<HTMLInputElement>) {
    const value = e.target.value
    onChange('#' + value)
  }

  function handleClick(color) {
    onChange(color)
  }

  return (
    <Popup trigger={trigger} on="click" style={{ width: 165 }}>
      {palette.some(() => true) && (
        <Table>
          <Table.Body>
            {chunk(palette, 4).map((group, i) => (
              <Table.Row key={i} width={4}>
                {group.map((color) => (
                  <Table.Cell key={color} textAlign="center" selectable style={{ cursor: 'pointer' }} onClick={(e) => handleClick(color)}>
                    <Label circular style={{ backgroundColor: color }}/>
                  </Table.Cell>
                ))}
                {times(group.length - 4, (i) => (
                  <Table.Cell key={i} content=""/>
                ))}
              </Table.Row>
            ))}
          </Table.Body>
        </Table>
      )}
      <Input label="#" value={value.replace(/#/g, "")} style={{ width: 100 }} onChange={handleChange}></Input>
    </Popup>
  )
}
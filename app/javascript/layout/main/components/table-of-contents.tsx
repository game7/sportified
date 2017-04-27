import * as React from 'react'
import * as ReactDOM from 'react-dom'
import { List } from 'semantic-ui-react'

interface Props {
}

export const TableOfContents = (props: Props) => {
  return (
    <List ordered>
      <List.Item as="a">Overview</List.Item>
      <List.Item as="a">Format</List.Item>
      <List.Item>
        <a>Divisions</a>
        <List.List>
          <List.Item as="a">A</List.Item>
          <List.Item as="a">B</List.Item>
          <List.Item as="a">C</List.Item>
          <List.Item as="a">D</List.Item>
          <List.Item as="a">O30</List.Item>
        </List.List>
      </List.Item>
    </List>
  )
}

export default TableOfContents

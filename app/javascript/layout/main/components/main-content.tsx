import * as React from 'react'
import * as ReactDOM from 'react-dom'
import { List } from 'semantic-ui-react'

interface Props {
}

export const MainContent = (props: Props) => {
  return (
    <div style={{ textAlign: 'justify' }}>
      <h2>Overview</h2>
      <p>
        Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa strong. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
      </p>
      <h2>Format</h2>
      <p>
        Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede link mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi.
      </p>
      <h2>Divisions</h2>
      <h3>A</h3>
      <List bulleted>
        <List.Item>Some feature to describe</List.Item>
        <List.Item>Another feature to describe and some other things about that item to describe</List.Item>
        <List.Item>And yet another thing to brag about</List.Item>
      </List>
      <h3>B</h3>
      <List bulleted>
        <List.Item>Some feature to describe</List.Item>
        <List.Item>Another feature to describe</List.Item>
        <List.Item>And yet another thing to brag about</List.Item>
      </List>
      <h3>C</h3>
      <List bulleted>
        <List.Item>Some feature to describe</List.Item>
        <List.Item>Another feature to describe</List.Item>
        <List.Item>And yet another thing to brag about</List.Item>
      </List>
    </div>
  )
}

export default MainContent

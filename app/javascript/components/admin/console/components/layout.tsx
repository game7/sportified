import React, { useState } from 'react'
import 'semantic-ui-css/semantic.css'
import { Menu, Container, Grid, Header, Divider, Dimmer, Loader } from 'semantic-ui-react'
import Navigation from './navigation';

interface Props {
  title?: string
  actions?: JSX.Element
  loading?: boolean
}

export const Console: React.FC<Props> = ({ title, children, actions, loading }) => {
  const [visible, setVisible] = useState(false)
  const content = children
  return (
    <React.Fragment>
      <Dimmer active={loading} page inverted>
        <Loader>Loading</Loader>
      </Dimmer>
      <Menu inverted style={{ borderRadius: 0 }}>
        <Container>
          {/* <Menu.Item onClick={() => { setVisible(!visible) }}>Item #1</Menu.Item> */}
        </Container>
      </Menu>
      <Grid>
        <Grid.Row>
          <Grid.Column width="2" textAlign="center">
            <Navigation />
          </Grid.Column>
          <Grid.Column width="14" textAlign="center">
            <Container textAlign="left">
              {title && (
                <>
                  <Grid>
                    <Grid.Row>
                      <Grid.Column width="10">
                        <Header as="h1">{title}</Header>
                      </Grid.Column>
                      <Grid.Column width="6" textAlign="right">
                        {actions}
                      </Grid.Column>
                    </Grid.Row>
                  </Grid>
                  <Divider></Divider>
                </>
              )}
              {content}
            </Container>
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </React.Fragment>
  )
}

export default Console;

import React, { useState } from 'react'
import 'semantic-ui-css/semantic.css'
import { Menu, Container, Grid, Header, Divider } from 'semantic-ui-react'
import Navigation from './navigation';

interface Props {
  title?: string
  actions?: JSX.Element
  loading?: boolean
}

export const Console: React.FC<Props> = ({ title, children, actions, loading }) => {
  const [visible, setVisible] = useState(false)
  const content = loading ? <div>Loading</div> : children
  return (
    <React.Fragment>
      <Menu style={{ borderRadius: 0 }} fixed="top">
        <Menu.Item icon="chevron left" />
      </Menu>
      <Grid>
        <Grid.Row>
          <Grid.Column width="2" textAlign="center">
            <Navigation />
          </Grid.Column>
          <Grid.Column width="14" textAlign="center">
            <Container textAlign="left" style={{ maxWidth: 720 }}>
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

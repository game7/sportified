import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Container, Sidebar, Breadcrumb, Menu, Header,Icon, Divider, Grid, List, Dropdown } from 'semantic-ui-react';
import {
  AccountMenu,
  Banner,
  Chrome,
  MainContent,
  NavMenu,
  PageActions,
  TableOfContents
} from './components';

interface WindowDimensions {
  height: number;
  width: number;
}

interface State {
  navExpanded: boolean
  accountExpanded: boolean
  window: WindowDimensions
}

interface Props {

}

export default class Main extends React.Component<Props, State> {

  toggleNav = () => {
    const { navExpanded } = this.state
    this.setState({
      navExpanded: !navExpanded,
      accountExpanded: false
    })
  }

  toggleAccount = () => {
    const { accountExpanded } = this.state
    this.setState({
      navExpanded: false,
      accountExpanded: !accountExpanded 
    })
  }

  setDimensions = () => {
    this.setState({
      window: {
        height: window.innerHeight,
        width: window.innerWidth
      }
    })
  }

  componentWillMount() {
    this.setState({
      navExpanded: false,
      accountExpanded: false
    });
    this.setDimensions();
  }

  componentDidMount() {
    window.addEventListener("resize", this.setDimensions)
  }

  render() {

    const {
      accountExpanded,
      navExpanded,
      window
    } = this.state;
    const {
      toggleNav,
      toggleAccount
    } = this;

    return (
      <div style={{height: '100%'}}>
        <Chrome
          onToggleNavMenu={toggleNav}
          onToggleAccountMenu={toggleAccount}
          navActive={navExpanded}
          accountActive={accountExpanded}
        />
        <Sidebar.Pushable as="div" style={{marginTop: -14}}>
          <NavMenu expanded={navExpanded} />
          <AccountMenu expanded={accountExpanded} />
          <Sidebar.Pusher>

            <Banner />
            <Container>
              <Grid>
                <Grid.Column width={10}>
                  <Header as="h1">
                    Adult Hockey
                  </Header>
                </Grid.Column>
                <Grid.Column width={6}>
                  <PageActions/>
                </Grid.Column>
              </Grid>
              <Divider/>
              <Grid divided stackable>
                <Grid.Column width={4}>
                  <TableOfContents/>
                </Grid.Column>
                <Grid.Column width={12}>
                  <MainContent/>
                </Grid.Column>
              </Grid>
              <Divider/>
              <Breadcrumb>
                <Breadcrumb.Section>Adult Hockey</Breadcrumb.Section>
                <Breadcrumb.Divider icon="right angle"/>
                <Breadcrumb.Section>Open Hockey</Breadcrumb.Section>
              </Breadcrumb>
              <Divider/>
            </Container>
          </Sidebar.Pusher>
        </Sidebar.Pushable>
      </div>
    );
  }
}

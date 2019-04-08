import * as React from 'react';
import { RouteComponentProps } from 'react-router-dom';
import { Item, Registration } from '../../../data';
import { Format, Sort } from '../../../utils';
import { Grid, Statistic, Card, Icon, Button, Form, Divider } from 'semantic-ui-react';
import * as moment from 'moment';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';

type ViewName = 'daily' | 'cumulative'

interface Props extends RouteComponentProps<{}> {
  item: Item
}

interface State {
  view: ViewName
}

export default class ItemDashboard extends React.Component<Props,State> {

  componentWillMount() {
    this.setState({ view: 'daily' })
  }

  setView = (view: ViewName) => {
    console.log(`setting view to: ${view}`)
    this.setState({ view })
  }

  renderStatistics = (registrations: Registration[]) => {

    const completed = registrations.filter(r => r.status == 'Completed')
    const revenue = completed.reduce((prev, next) => {
      return prev + next.price;
    }, 0);

    return (
      <Grid columns={3} divided>
        <Grid.Row>
          <Grid.Column textAlign="center">
            <Statistic value={completed.length} label="Completed"/>
          </Grid.Column>
          <Grid.Column textAlign="center">
            <Statistic value={registrations.length} label="Total"/>
          </Grid.Column>
          <Grid.Column textAlign="center">
            <Statistic value={Format.dollars(revenue)} label="Revenue"/>
          </Grid.Column>
        </Grid.Row>
      </Grid>
    );

  }

  render() {
    const { item = ({} as Item) } = this.props;
    const { view } = this.state;
    const { registrations = ([] as Registration[]) } = item;

    const description = "Amy is a violinist with 2 years experience in the wedding industry. She enjoys the outdoors and currently resides in upstate New York.";

    return (
      <div>
        <Divider/>
        {this.renderStatistics(registrations)}
        <Divider/>
        <Grid>
          <Grid.Row>
            <Grid.Column width={16}>
              <div style={{ marginBottom: 15 }}>
                <Button.Group>
                  <Button
                    active={view == 'daily'}
                    onClick={() => this.setView('daily')}
                  >
                    Daily
                  </Button>
                  <Button
                    active={view == 'cumulative'}
                    onClick={() => this.setView('cumulative')}
                  >
                    Cumulative
                  </Button>
                </Button.Group>
              </div>
              <Charts
                registrations={registrations}
                cumulative={view == 'cumulative'}
              />
            </Grid.Column>
            {/*
            <Grid.Column width={4}>

            </Grid.Column>
            */}
          </Grid.Row>
        </Grid>
      </div>

    )
  }

}

const Charts = (props: { registrations: Registration[], cumulative: boolean}) => {

  const { registrations, cumulative } = props;

  const completed = registrations.filter(r => r.status == 'Completed');
  const sorted = Sort(completed).asc(c => moment(c.updatedAt).format('YY-MM-DD'));

  if(sorted.length == 0) return <div>There are no completed registrations</div>

  const start = moment(sorted[0].createdAt).startOf('day');
  const end = moment(sorted[sorted.length-1].createdAt).startOf('day')

  const salesByDate = sorted.reduce((prev, next) => {
    const date = Format.shortDate(next.updatedAt);
    const counter = prev[date] || 0;
    const result =  {
      ...prev,
      [date]: counter + 1
    }
    return result;
  }, {}) as {
    [date: string]: number;
  }

  const revenueByDate = sorted.reduce((prev, next) => {
    const date = Format.shortDate(next.updatedAt);
    const revenue = prev[date] || 0;
    return {
      ...prev,
      [date]: revenue + next.price
    }
  }, {}) as {
    [date: string]: number;
  }

  let data = [];
  let sold = 0;
  let revenue = 0;
  let totalRevenue = 0;
  const days = moment(end).diff(moment(start), 'days');

  for (var i = 0; i <= days; i++) {
    const date = moment(start).add(i, 'days').format('M/D/YY');

    if (cumulative) {
      sold = sold + (salesByDate[date] || 0);
      revenue = revenue + (revenueByDate[date] || 0);
      totalRevenue = revenue;
    } else {
      sold = (salesByDate[date] || 0);
      revenue = (revenueByDate[date] || 0);
      totalRevenue = totalRevenue + revenue;
    }
    data.push({
      name: date,
      sold,
      revenue
    })
  }

  return (

    <div>
      <Card fluid>
        <Card.Content header='Registrations Completed' />
        <Card.Content style={{ height: 320 }}>
          <LineChart width={600} height={300} data={data}
                margin={{top: 5, right: 30, left: 20, bottom: 5}}
                style={{ display: 'block', margin: 'auto' }}>
            <XAxis dataKey="name"/>
            <YAxis/>
            <CartesianGrid strokeDasharray="3 3"/>
            <Tooltip/>
            <Legend />
            <Line type="monotone" dataKey="sold" stroke="#8884d8" activeDot={{r: 8}}/>
          </LineChart>
        </Card.Content>
        <Card.Content extra>
          {completed.length} Total
        </Card.Content>
      </Card>

      <Card fluid>
        <Card.Content header='Registration Revenue' />
        <Card.Content style={{ height: 320 }}>
          <LineChart width={600} height={300} data={data}
                margin={{top: 5, right: 30, left: 20, bottom: 5}}
                style={{ display: 'block', margin: 'auto' }}>
            <XAxis dataKey="name"/>
            <YAxis/>
            <CartesianGrid strokeDasharray="3 3"/>
            <Tooltip/>
            <Legend />
            <Line type="monotone" dataKey="revenue" stroke="#8884d8" activeDot={{r: 8}}/>
          </LineChart>
        </Card.Content>
        <Card.Content extra>
          {Format.dollars(totalRevenue)} Total
        </Card.Content>
      </Card>
    </div>

  )

}

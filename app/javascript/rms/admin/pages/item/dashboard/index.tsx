import React, { FC, useState } from 'react';
import { RouteComponentProps } from 'react-router-dom';
import { Item, Registration } from '../../../data';
import { Format, Sort } from '../../../utils';
import { Grid, Statistic, Card, Icon, Button, Form, Divider } from 'semantic-ui-react';
import * as moment from 'moment';
import { BarChart, XAxis, YAxis, CartesianGrid, Tooltip, Legend, Bar } from 'recharts';

type ViewName = 'daily' | 'cumulative'

interface Props extends RouteComponentProps<{}> {
  item: Item
}

export const ItemDashboard: FC<Props> = ({ item }) => {

  const [view, setView] = useState<ViewName>('daily')
  const { registrations = ([] as Registration[]) } = item;

  return (
    <div>
      <Divider/>
      <Statistics registrations={registrations} />
      <Divider/>
      <Grid>
        <Grid.Row>
          <Grid.Column width={16}>
            <div style={{ marginBottom: 15 }}>
              <Button.Group>
                <Button
                  active={view == 'daily'}
                  onClick={() => setView('daily')}
                >
                  Daily
                </Button>
                <Button
                  active={view == 'cumulative'}
                  onClick={() => setView('cumulative')}
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
        </Grid.Row>
      </Grid>
    </div>

  )

}

export default ItemDashboard;

const Statistics: FC<{ registrations: Registration[] }> = ({ registrations }) => {

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

const Charts: FC<{ registrations: Registration[], cumulative: Boolean }> = ({ registrations, cumulative }) => {

  const sorted = Sort(registrations).asc(c => moment(c.updatedAt).format('YY-MM-DD'));

  if(sorted.length == 0) return <div>There are no completed registrations</div>

  const start = moment(sorted[0].createdAt).startOf('day');
  const end = moment(sorted[sorted.length-1].createdAt).startOf('day')
  
  const byDate = sorted.reduce((prev, next) => {
    const date = Format.shortDate(next.updatedAt);
    const data = prev[date] || {
      started: 0,
      completed: 0,
      revenue: 0
    }
    return {
      ...prev,
      [date]: {
        started: next.status == "Completed" ? data.started : data.started + 1,
        completed: next.status == "Completed" ? data.completed + 1 : data.completed,
        revenue: next.status == "Completed" ? data.revenue + next.price : data.revenue
      }
    }
  }, {}) as {
    [date: string]: {
      started: number;
      completed: number;
      revenue: number;
    };
  }

  const data = [];
  const days = moment(end).diff(moment(start), 'days');
  const total = {
    started: 0,
    completed: 0,
    revenue: 0
  }

  for (var i = 0; i <= days; i++) {
    const date = moment(start).add(i, 'days').format('M/D/YY');
    const day = byDate[date] || {
      started: 0,
      completed: 0,
      revenue: 0
    };
    total.started = total.started + day.started;
    total.completed = total.completed + day.completed;
    total.revenue = total.revenue + day.revenue;
    if (cumulative) {
      data.push({
        name: date,
        ...total
      })
    } else {
      data.push({
        name: date,
        ...day
      })
    }
  }

  return (
    <div>
      <Card fluid>
        <Card.Content header='Registrations' />
        <Card.Content style={{ height: 320 }}>
          <BarChart width={600} height={300} data={data}
                margin={{top: 5, right: 30, left: 20, bottom: 5}}
                style={{ display: 'block', margin: 'auto' }}>
            <XAxis dataKey="name"/>
            <YAxis/>
            <CartesianGrid strokeDasharray="3 3"/>
            <Tooltip/>
            <Legend />
            <Bar dataKey="started" stackId="a" fill="#82ca9d" />    
            <Bar dataKey="completed" stackId="a" fill="#8884d8" />    
          </BarChart>
        </Card.Content>
        <Card.Content extra>
          {total.started} Started + {total.completed} Completed
        </Card.Content>
      </Card>

      <Card fluid>
        <Card.Content header='Revenue' />
        <Card.Content style={{ height: 320 }}>
          <BarChart width={600} height={300} data={data}
                margin={{top: 5, right: 30, left: 20, bottom: 5}}
                style={{ display: 'block', margin: 'auto' }}>
            <XAxis dataKey="name"/>
            <YAxis/>
            <CartesianGrid strokeDasharray="3 3"/>
            <Tooltip/>
            <Legend />
            <Bar dataKey="revenue" stackId="a" fill="#82ca9d" />
          </BarChart>
        </Card.Content>
        <Card.Content extra>
          {Format.dollars(total.revenue)} Total
        </Card.Content>
      </Card>
    </div>
  )

}

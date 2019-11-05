import React, { FC, useState, useEffect } from 'react';
import moment from 'moment';
import * as $ from 'jquery';
import { Store, Event, Tag } from './store';
import 'react-select/dist/react-select.css';
import './styles.scss'
import './calendar.css'
import { withRouter, RouteComponentProps } from 'react-router';
// import { Modal, Static, TagList } from './components';
// import { getTextColor } from './utils';
import 'semantic-ui-css/semantic.css'
import { Modal, Form, Popup, Label, Button, Table, Grid, Icon, Dropdown } from 'semantic-ui-react';
import DateTimePicker from './date-time-picker';
import DateTimeInput from './date-time-input';
import { times } from './utils';

interface Props { }

function dateToString(date: Date) {
  return moment(date).format('YYYY/MM/DD')
}

const Page: FC<RouteComponentProps<Props>> = ({ history, location }) => {
  const params = new URLSearchParams(location.search)
  const view = (params.get('view') || 'week')
  const date = params.has('date') ? new Date(params.get('date')) : new Date()
  const month = moment(date).format('YYYY-MM')
  const [events, setEvents] = useState<Event[]>([])
  const [tags, setTags] = useState<Record<string, Tag>>({})
  const [selection, setSelection] = useState<Event>()

  useEffect(function getEvents() {
    Store.getEvents(date).then(setEvents);
  }, [month]);

  useEffect(function getTags() {
    const tags = $('#scheduler').data('tags') as Tag[];
    const dict = tags.reduce((result, tag) => ({
      ...result,
      [tag.id]: tag
    }), {}) as Record<string, Tag>
    setTags(dict)
  }, [])

  function goBack() {
    const to = moment(date).add(-1, 'month').toDate();
    history.push({
      search: `?view=${view}&date=${dateToString(to)}`
    })
  }

  function goForward() {
    const to = moment(date).add(1, 'month').toDate();
    history.push({
      search: `?view=${view}&date=${dateToString(to)}`
    })
  }

  function goToday() {
    const to = moment().toDate();
    history.push({
      search: `?view=${view}&date=${dateToString(to)}`
    })
  }

  function goToDate(date: Date) {
    console.log(date)
    history.push({
      search: `?view=${view}&date=${dateToString(date)}`
    })
  }

  function download() {
    window.location.href = `/admin/events.csv?date=${moment(date).format('YYYY-MM-DD')}`
  }

  function trim(str: string) {
    if(str.length >= 20) {
      return str.substring(0, 18) + '...'
    }
    return str;
  }

  const MonthEvent: FC<{event: Event}> = ({ event }) => {
    const tag = tags[event.tags[0]];
    const tagColor = (tag && tag.color) || '#999999';
    const style = {
      fontSize: 12,
      padding: '0 2px',
      color: '#000000',
      backgroundColor: `${tagColor}40`,
      // border: `1px solid ${tagColor}`,
      borderLeft: `8px solid ${tagColor}`,
      marginBottom: 1,
      whiteSpace: 'nowrap',
      overflow: 'hidden',
      textOverflow: 'ellipsis',
      cursor: 'pointer'
    } as React.CSSProperties
    const Event = (
      <div style={style}>
        {moment(event.startsOn).format('h:mm')} {trim(event.summary)}
      </div>
    )

    return (
      <Modal trigger={Event} scrolling={false} >
        <Modal.Header>{event.summary}</Modal.Header>
        <Modal.Content>
          <Form>
            <Form.Field>
              <label>Summary</label>
              <input value={event.summary} style={{ width: 400 }}/>
            </Form.Field>
            <DateTimeInput label="Date / Time" />
            <Form.Field>
              <label>Duration</label>
              <input value={event.duration} style={{ width: 50 }}/>
            </Form.Field>
            <Form.Field>
              <label>Tags</label>
              <input value={event.tags.map(t => tags[t].name).join(', ')} style={{ width: 400 }}/>
            </Form.Field>
          </Form>
        </Modal.Content>
      </Modal>
    )
  }

  // const AgendaEvent: FC<{event: Event}> = ({ event }) => {
  //   const tag = tags[event.tags[0]];
  //   const tagColor = (tag && tag.color) || '#999999';
  //   const style = {
  //     padding: '5px 10px',
  //     color: '#000000',
  //     // backgroundColor: `${tagColor}40`,
  //     borderLeft: `0px solid ${tagColor}`,
  //     height: '100%',
  //     verticalAlign: 'middle'
  //   };
  //   const dot = {
  //     height: 14,
  //     width: 14,
  //     backgroundColor: tagColor,
  //     borderRadius: '50%',
  //     display: 'inline-block',
  //     marginRight: 8,
  //     marginBottom: -1
  //   }
  //   return (
  //     <div style={style}>
  //       <span style={dot}/>
  //       {event.summary}
  //     </div>
  //   )
  // }

  function renderDay(day) {
    const cellDay = moment(day);
    const isToday = cellDay.format('YYMMDD') == moment().format('YYMMDD');
    const isCurrentMonth = cellDay.month() != moment(date).month();
    const dayEvents = events.filter(e => cellDay.isSame(e.startsOn, 'day'))
    return (
      <Table.Cell
        key={cellDay.format('YYMMDD')}
        disabled={isCurrentMonth}
        style={{
          backgroundColor: isToday && '#2196f329',
          height: 200,
          padding: 1,
          textOverflow: 'ellipsis',
          whiteSpace: 'nowrap',
          verticalAlign: "top"
        }}
      >
        <div style={{ padding: 4 }}>{cellDay.format('D')}</div>
        {dayEvents.map(e => (
          <MonthEvent key={e.id} event={e} />
        ))}
      </Table.Cell>
    )
  }

  function renderDays() {
    const rows = [];
    let day = moment(date).startOf('month').startOf('week').add(-1,'day');

    while(moment(day).add(1,'day').month() != moment(date).add(1,'month').month()){
      rows.push(
        <Table.Row key={day.format('YYMMDD')}>
          {times(7).map(() => {
            day.add(1,'day');
            return renderDay(day);
          })}
        </Table.Row>
      )
    }
    return rows;
  }

  return (
    <React.Fragment>
      <Grid columns={3}>
        <Grid.Column textAlign="left">
          <Button.Group basic>
            <Button icon onClick={goBack}>
              <Icon name="chevron left"/>
            </Button>
            <Button onClick={goToday}>
              Today
            </Button>
            <Button icon onClick={goForward}>
              <Icon name="chevron right"/>
            </Button>
          </Button.Group>
        </Grid.Column>
        <Grid.Column textAlign="center" verticalAlign="middle">
          <DateTimePicker
            type="month"
            trigger={
              <Button basic>
                <Icon name="calendar"/>
                {moment(date).format("MMMM YYYY")}
              </Button>
            }
            onSelect={goToDate}
          ></DateTimePicker>

        </Grid.Column>
        <Grid.Column textAlign="right">
          <Button basic icon="download" onClick={download} />
          <Dropdown button basic text="New Event">
            <Dropdown.Menu>
              <Dropdown.Header>General</Dropdown.Header>
              <Dropdown.Item onClick={() => { window.location.href = '/admin/general/events/new' }}>Event</Dropdown.Item>
              <Dropdown.Divider/>
              <Dropdown.Header>League</Dropdown.Header>
              <Dropdown.Item onClick={() => { window.location.href = '/admin/league/games/new' }}>Game</Dropdown.Item>
              <Dropdown.Item onClick={() => { window.location.href = '/admin/league/events/new' }}>Event</Dropdown.Item>
            </Dropdown.Menu>
          </Dropdown>
        </Grid.Column>
      </Grid>
      <Table columns={7} celled>
        <Table.Header>
          <Table.Row textAlign="center">
            {times(7).map((_, i) => (
              <Table.HeaderCell key={i}>{moment().day(i).format('dddd')}</Table.HeaderCell>
            ))}
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {renderDays()}
        </Table.Body>
      </Table>
    </React.Fragment>
  )

}

export default withRouter(Page);

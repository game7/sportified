import React, { FC, useState } from 'react';
import { Event, LockerRoom } from './types';
import { Header, Table, Button, Grid } from 'semantic-ui-react';
import { debounce, pick } from 'lodash';
import { EventRow } from './event-row';
import moment from 'moment';

interface Props {
  date: string;
  events: Event[];
  lockerRooms: LockerRoom[];
  canEdit?: boolean
}


const handleUpdateEvent = debounce(async (event: Event) => { 
  const url = `/admin/events/${event.id}`
  const method = 'PATCH'
  const headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  }    
  const body = JSON.stringify({ event: pick(event, "awayTeamName", "homeTeamName", "awayTeamLockerRoomId", "homeTeamLockerRoomId") })
  const response = await fetch(url, { method, headers, body })
  if(response.ok) {

  } else {

  }
}, 1000)

const LockerRooms: FC<Props> = (props) => {
  const DATE_FORMAT = 'YYYY-MM-DD'
  const { lockerRooms } = props;
  const [date, setDate] = useState(props.date);
  const [events, setEvents] = useState(props.events);
  const [loading, setLoading] = useState(false)

  async function handleAutoAssignClick() {
    if(loading) { return }
    setLoading(true)
    const url = `/admin/events/locker_rooms/assign?date=${date}`
    const method = 'POST'
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const response = await fetch(url, { method, headers })
    if(response.ok) {
      const payload = await response.json() as Event[]
      setEvents(payload)
      setLoading(false)
    } else {
      
    }    
  }

  async function loadEvents(date: string) {
    setLoading(true)
    const url = `/admin/events/?view=day&date=${date}` 
    const method = 'GET'
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
    const response = await fetch(url, { method, headers })
    setEvents(await response.json() as Event[])
    setLoading(false)
  }

  function updateEvent(updated: Event) {
    setEvents(events => events.map(event => event.id === updated.id ? updated : event));
    handleUpdateEvent(updated);
  }

  async function deleteEvent(toDelete: Event) {
    setLoading(true)
    const url = toDelete.deleteUrl;
    const method = 'DELETE'
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
    await fetch(url, { method, headers })
    setEvents(events => events.filter(e => e.id !== toDelete.id))
    setLoading(false)    
  }

  function handlePreviousDate() {
    const newDate = moment(date).subtract(1, "day").format(DATE_FORMAT)
    setDate(newDate)
    loadEvents(newDate)  
  }

  function handleToday() {
    const newDate = moment().format(DATE_FORMAT)
    setDate(newDate)
    loadEvents(newDate)  
  }

  function handleNextDate() {
    const newDate = moment(date).add(1, "day").format(DATE_FORMAT)
    setDate(newDate)
    loadEvents(newDate)  
  }

  return (
    <React.Fragment>
      <Header as="h3">Events for {moment(date).format("dddd MMMM Do")}</Header>
      <Grid columns="2">
        <Grid.Column>
          <Button.Group>
            <Button icon="chevron left" onClick={handlePreviousDate} disabled={loading} />
            <Button content="Today" onClick={handleToday} disabled={loading} />
            <Button icon="chevron right" onClick={handleNextDate} disabled={loading} />
          </Button.Group>
        </Grid.Column>
        <Grid.Column textAlign="right">
          <Button primary content="Auto Assign" onClick={handleAutoAssignClick} disabled={loading} />
        </Grid.Column>
      </Grid>
      <Table celled striped>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell content="Time" />
            <Table.HeaderCell content="Summary" />
            <Table.HeaderCell content="Away Team" />
            <Table.HeaderCell content="Home Team" />
            {props.canEdit && (
              <Table.HeaderCell content="" />
            )} 
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {events.map(event => (<EventRow key={event.id} {...{event, updateEvent, deleteEvent, lockerRooms}} />))}
        </Table.Body>
      </Table>
    </React.Fragment>
  )
}

export default LockerRooms;
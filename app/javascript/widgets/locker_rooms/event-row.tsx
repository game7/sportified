import React, { FC } from 'react';
import moment from 'moment';
import { Event, LockerRoom } from './types';
import { Table, Button, Form, Dropdown, Icon } from 'semantic-ui-react';

interface EventRowProps {
  event: Event;
  updateEvent: (event) => void;
  deleteEvent: (event) => void;
  lockerRooms: LockerRoom[];
  canEdit?: boolean;
}

export const EventRow: FC<EventRowProps> = ({ event, updateEvent, deleteEvent, lockerRooms, canEdit }) => {

  function makeOnChangeHandler(eventId: number, attr: keyof Event) {
    return async function handleChange(_e, { value }) {
      updateEvent({ ...event, [attr]: value })
    }
  }
  
  function makeOnClickHandler(eventId: number, attr: keyof Event, value: number) {
    return async function handleChange(e: React.MouseEvent<HTMLButtonElement>) {
      e.preventDefault();
      updateEvent({ ...event, [attr]: value })
    }
  }  

  return (
    <Table.Row>
      <Table.Cell content={moment(event.startsOn).format('h:mm a')} />
      <Table.Cell content={event.summary} />
      <Table.Cell>
        <Form>
          <Form.Input label={false} value={event.awayTeamName || ""} onChange={makeOnChangeHandler(event.id, "awayTeamName")}/>
          <Button.Group>
            {lockerRooms.filter(room => room.locationId === event.locationId).map(room => (
              <Button key={room.id} content={room.name} active={room.id === event.awayTeamLockerRoomId} onClick={makeOnClickHandler(event.id, "awayTeamLockerRoomId", room.id)} />
            ))}
          </Button.Group>
        </Form>
      </Table.Cell>
      <Table.Cell>
        <Form>
          <Form.Input label={false} value={event.homeTeamName || ""} onChange={makeOnChangeHandler(event.id, "homeTeamName")}/>
          <Button.Group>
            {lockerRooms.filter(room => room.locationId === event.locationId).map(room => (
              <Button key={room.id} content={room.name} active={room.id === event.homeTeamLockerRoomId} onClick={makeOnClickHandler(event.id, "homeTeamLockerRoomId", room.id)} />
            ))}
          </Button.Group>
        </Form>            
      </Table.Cell>
      {canEdit && (
        <Table.Cell collapsing textAlign="center">
          <Dropdown icon={<Icon name="ellipsis horizontal" fitted />}>
            <Dropdown.Menu direction="left">
              <Dropdown.Header content="Event" />
              <Dropdown.Item as="a" content="Edit" href={event.editUrl} />
              <Dropdown.Item as="a" content="Clone" href={event.cloneUrl} />
              <Dropdown.Item as="a" content="Delete" onClick={() => deleteEvent(event)} />
              {event.type == "League::Game" && (
                <React.Fragment>
                <Dropdown.Header content="Game" />
                  <Dropdown.Item as="a" content="Result" href={event.resultUrl} />
                  <Dropdown.Item as="a" content="Statsheet" href={event.statsheetUrl} />
                  <Dropdown.Item as="a" content="Print Scoresheet" href={event.printScoresheetUrl} />
                </React.Fragment>
              )}
            </Dropdown.Menu>
          </Dropdown>
        </Table.Cell>
      )}
    </Table.Row>    
  )
}
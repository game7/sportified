import * as React from 'react';
import * as BigCalendar from 'react-big-calendar';
import * as moment from 'moment';
import 'react-big-calendar/lib/css/react-big-calendar.css';
import { Store, Event } from './store';
import { Row, Col } from './layout';

BigCalendar.momentLocalizer(moment);



interface State {
  events: Event[]
}

export default class Calendar extends React.Component<{}, State> {

  constructor(props) {
    super(props)
    this.state = {
      events: []
    };
    this.onNavigate = this.onNavigate.bind(this);
  }

  componentDidMount() {
    this.fetchEvents(new Date());
  }

  onNavigate(date: Date, view: string) {
    this.fetchEvents(date);
  }

  fetchEvents(date: Date) {
    Store.getEvents(date).then(events => {
      this.setState({
        events: events
      });
    });
  }

  render() {
    const { events } = this.state
    return (
      <Row>
        <Col sm={2}>
        </Col>
        <Col sm={10}>
          <div style={{height: 800, marginTop: 20}}>
            <BigCalendar
              events={events}
              startAccessor='startsOn'
              endAccessor='endsOn'
              titleAccessor='summary'
              onNavigate={this.onNavigate}
            />
          </div>
        </Col>
      </Row>
    );
  }
}

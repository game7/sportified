import React from 'react';
import BigCalendar from 'react-big-calendar';
import moment from 'moment';
import * as _ from 'lodash';
import 'react-big-calendar/lib/css/react-big-calendar.css';
import { Store, Event, Tag } from './store';
import { Row, Col } from './layout';
import Select from 'react-select';
import { Option } from 'react-select';
import 'react-select/dist/react-select.css';
import './styles.css'


BigCalendar.momentLocalizer(moment);

interface TagMap {
  [id: string]: Tag
}

interface Filter {
  tags: string;
}

interface State {
  events: Event[];
  tags: TagMap;
  eventTags: Set<string>;
  filter: Filter;
  selectedEvent: Event;
}

export default class Calendar extends React.Component<{}, State> {

  readonly state: State = {
    events: [],
    tags: {},
    filter: {
      tags: ''
    },
    eventTags: new Set<string>([]),
    selectedEvent: null
  };

  componentDidMount() {
    this.fetchEvents(new Date());
    this.fetchTags();
  }

  private onNavigate = (date: Date, view: string) => {
    console.log('new date', date);
    this.fetchEvents(date);
    this.findStartAndEndDate(date, view);
  }

  onView(view: string) {
    console.log(view)
  }

  onRangeChange(range: any) {
    console.log(range)
  }

  private handleSelectEvent = (event: Event) => {
    this.setState({ selectedEvent: event })
  }

  private handleSelectChange = (value) => {
    const { filter } = this.state;
    const updated = {...filter, tags: value};
    this.setState({ filter: updated });
    console.log(value)
  }

  private closeModal = () => {
    this.setState({ selectedEvent: null })
  }

  fetchTags() {
    Store.getTags().then(tags => {
      const map = tags.reduce((result, tag) => {
        result[tag.id] = tag;
        return result;
      }, {});
      this.setState({ tags: map })
    })
  }

  findStartAndEndDate(date: Date, view: string) {
    let start, end;
    // if view is day: from moment(date).startOf('day') to moment(date).endOf('day');
    if(view === 'day'){
      start = moment(date).startOf('day');
      end   = moment(date).endOf('day');
    }
    // if view is week: from moment(date).startOf('isoWeek') to moment(date).endOf('isoWeek');
    else if(view === 'week'){
      start = moment(date).startOf('isoWeek');
      end   = moment(date).endOf('isoWeek');
    }
    //if view is month: from moment(date).startOf('month').subtract(7, 'days') to moment(date).endOf('month').add(7, 'days'); i do additional 7 days math because you can see adjacent weeks on month view (that is the way how i generate my recurrent events for the Big Calendar, but if you need only start-end of month - just remove that math);
    else if(view === 'month'){
      start = moment(date).startOf('month').subtract(7, 'days');
      end   = moment(date).endOf('month').add(7, 'days');
    }
    // if view is agenda: from moment(date).startOf('day') to moment(date).endOf('day').add(1, 'month');
    else if(view === 'agenda'){
      start = moment(date).startOf('day');
      end   = moment(date).endOf('day').add(1, 'month');
    }
    console.log(start.toString(), end.toString())
  }

  fetchEvents(date: Date) {
    Store.getEvents(date).then(events => {
      const tags = events.reduce((result, event) => (result.concat(event.tags)), [])
      this.setState({
        events: events,
        eventTags: new Set<string>(tags)
      });
    });
  }

  private filterEvents = (events: Event[], filter: Filter) => {
    if(filter.tags == '') return [...events];
    const tags = filter.tags.split(',');
    return events.filter(event => {
      const intersection = _.intersection(tags, event.tags)
      return (intersection.length > 0);
    })
  }

  modal(event: Event) {
    if(!event) return (<div/>)
    return (
      <React.Fragment>
        <div className="modal fade in show" role="dialog">
          <div className="modal-dialog" role="document">
            <div className="modal-content">
              <div className="modal-header">
                <h5 className="modal-title">{event.summary}</h5>
                <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div className="modal-body">
                <p>Modal body text goes here.</p>
              </div>
              <div className="modal-footer">
                {/*<button type="button" className="btn btn-primary">Save changes</button>*/}
                <button type="button" className="btn btn-secondary" onClick={this.closeModal}>Close</button>
              </div>
            </div>
          </div>
        </div>
        <div className="modal-backdrop fade in"/>
      </React.Fragment>
    )
  }

  render() {
    const { events, tags, eventTags, filter } = this.state;

    type stringOrDate = string | Date;
    const eventPropGetter = (event: Object, start: stringOrDate, end: stringOrDate, isSelected: boolean) => {
      const tags = event['tags'] || [];
      const first = tags[0] || {};
      const color = first.color;
      return {
        style: {
          backgroundColor: color,
          borderRadius: 0
        }
      };
    }

    const keys = Object.keys(tags).filter(key => eventTags.has(key));
    const options = keys.map(key => tags[key]).map(tag => ({ label: tag.name, value: tag.id } as Option<string>));

    const filteredEvents = this.filterEvents(events, filter);

    return (
      <div>
        {this.modal(this.state.selectedEvent)}
        <div className="alert alert-info" role="alert">
          This is the new snappier calendar. it's still coming together but has been released
          so that we can try it out with live data
        </div>
        <Row>
          {/*<Col sm={2}>*/}
            {/*{JSON.stringify(this.state.filter)}*/}
            {/*<TagList tags={tags} visible={eventTags}/>*/}
          {/*</Col>*/}
          <Col sm={12}>
            {/*<div className="btn-group" role="group" >*/}
              {/*<button type="button" className="btn btn-default">Today</button>*/}
              {/*<button type="button" className="btn btn-default">Back</button>*/}
              {/*<button type="button" className="btn btn-default">Next</button>*/}
            {/*</div>*/}
            {/*<div className="btn-group" role="group" >*/}
              {/*<button type="button" className="btn btn-default">Month</button>*/}
              {/*<button type="button" className="btn btn-default">Week</button>*/}
              {/*<button type="button" className="btn btn-default">Work Week</button>*/}
              {/*<button type="button" className="btn btn-default">Day</button>*/}
              {/*<button type="button" className="btn btn-default">Agenda</button>*/}
            {/*</div>*/}
            <Select
              multi
              onChange={this.handleSelectChange}
              options={options}
              placeholder="Filter by Tag(s)"
              simpleValue
              value={filter.tags}
            />
            <div style={{height: 800, marginTop: 20}}>
              <BigCalendar
                events={filteredEvents}
                startAccessor='startsOn'
                endAccessor='endsOn'
                titleAccessor='summary'
                views={['month','week','work_week','day','agenda']}
                popup
                eventPropGetter={eventPropGetter}
                onNavigate={this.onNavigate}
                onView={this.onView.bind(this)}
                defaultDate={new Date()}
                selectable
                onSelectEvent={this.handleSelectEvent}
              />
            </div>
          </Col>
        </Row>
      </div>
    );
  }
}


interface TagListProps {
  tags: TagMap;
  visible: Set<string>;
}

const TagList: React.SFC<TagListProps> = (props) => {
  const keys = Object.keys(props.tags).filter(key => props.visible.has(key));
  if (keys.length == 0) { return <div/>; }
  const tags = keys.map(key => props.tags[key]);
  return (
    <div className="list-group">
      {tags.map(tag => (
        <div className="list-group-item" key={tag.id} style={{ backgroundColor: tag.color }}>
          {tag.name}
        </div>
      ))}
    </div>
  )
}

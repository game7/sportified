import React from 'react';
import BigCalendar from 'react-big-calendar';
import moment from 'moment';
import * as $ from 'jquery';
import * as _ from 'lodash';
import 'react-big-calendar/lib/css/react-big-calendar.css';
import { Store, Event, Tag } from './store';
import { Row, Col } from './layout';
import Select from 'react-select';
import { Option } from 'react-select';
import 'react-select/dist/react-select.css';
import './styles.css'
import { withRouter, RouteComponentProps } from 'react-router';
import { Modal, Static, TagList } from './components';
import { getTextColor } from './utils';

const Params = {
  parse: (search: string) => {
    const qs = search.split('?')[1] || '';
    if (qs == '') return {};
    const pairs = qs.split('&');
    const sets = pairs.map(pair => pair.split('='));
    const params = sets.reduce((result, curr) => { result[curr[0]] = curr[1]; return result; }, {});
    return params;
  },
  stringify: (params: any) => {
    const keys = Object.keys(params);
    if(keys.length == 0) return '';
    return '?' + keys.map(key => `${key}=${params[key]}`).join('&')
  }
}

BigCalendar.momentLocalizer(moment);

interface TagMap {
  [id: string]: Tag
}
interface State {
  events: Event[];
  tags: TagMap;
  eventTags: Set<string>;
  filter: Filter;
  selectedEvent: Event;
}

function initialize() {

  // prepare tags
  const tags = $('#scheduler').data('tags');
  const tagMap = tags.reduce((result, tag) => {
    result[tag.id] = tag;
    return result;
  }, {});

  // prepare events
  const eventData = $('#scheduler').data('events') as any[];
  const events = eventData.map(event => ({
    ...event,
    startsOn: new Date(event.startsOn),
    endsOn: new Date(event.endsOn)
  } as Event));
  const eventTags = events.reduce((result, event) => (result.concat(event.tags)), [])

  return {
    events: events,
    tags: tagMap,
    filter: {
      tags: ''
    },
    eventTags: new Set<string>(eventTags),
    selectedEvent: null
  };
}

class Calendar extends React.Component<RouteComponentProps<{}>, State> {

  readonly state: State = initialize();

  private push(params: any) {
    const current = Params.parse(this.props.location.search);
    const updated = {...current, ...params};
    const search = Params.stringify(updated);
    this.props.history.push({ search });
  }

  private onNavigate = (date: Date, view: string) => {
    console.log('onNavigate', date, view);
    this.fetchEvents(date);
    const short = date.toISOString().split('T')[0]
    this.push({ date: short })
    this.findStartAndEndDate(date, view);
  }

  private onView = (view: string) => {
    console.log('onView', view)
    this.push({ view });
  }

  private onRangeChange = (range: any) => {
    console.log('onRangeChange', range)
  }

  private handleSelectEvent = (event: Event) => {
    this.setState({ selectedEvent: event })
  }

  private handleSelectChange = (value) => {
    console.log(value)
    const { filter } = this.state;
    const updated = {...filter, tags: value};
    this.setState({ filter: updated });
  }

  private closeModal = () => {
    this.setState({ selectedEvent: null })
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
    // console.log(start.toString(), end.toString())
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

  private handleColorChange = (id: string, color: string) => {
    const { tags } = this.state;
    const tag = { ...tags[id], color };
    const updated = { ...tags, [id]: tag };
    this.setState({ tags: updated });
    Store.updateTag(id, color)
  }

  modal(event: Event, options: Option<string>[]) {
    if(!event) return (<div/>)
    const tags = event.tags.map(id => this.state.tags[id]);
    return (
      <Modal title={event.summary} onClose={this.closeModal}>
        <Static label="Starts At">{event.startsOn.toLocaleDateString()}</Static>
        <Static label="Ends At">{event.endsOn.toLocaleDateString()}</Static>
        <Static label="Tags">
          <Select
            multi
            options={options}
            placeholder="Filter by Tag(s)"
            simpleValue
            value={event.tags}
          />
        </Static>
        <Static label="Tags">
          <TagList
            tags={tags}
            onColorChange={this.handleColorChange}
          />
        </Static>
      </Modal>
    )
  }

  render() {
    const { events, tags, eventTags, filter } = this.state;;
    const params = Params.parse(this.props.location.search);
    const view = params['view'] as string || 'month'
    const date = params['date'] ? new Date(Date.parse(params['date'])) : new Date();
    type stringOrDate = string | Date;
    const eventPropGetter = (event: Object, start: stringOrDate, end: stringOrDate, isSelected: boolean) => {
      if (view == 'agenda') return {}
      const first = (event['tags'] || [])[0];
      const tag = tags[first] || {};
      const background = tag['color'] || '#DEDEDE';
      return {
        style: {
          backgroundColor: background,
          color: getTextColor(background),
          borderRadius: 0
        }
      };
    }

    const min = moment().startOf('day').add(6, 'hour').toDate();

    const keys = Object.keys(tags).filter(key => eventTags.has(key));
    const options = keys.map(key => tags[key]).map(tag => ({ label: tag.name, value: tag.id } as Option<string>));

    const filteredEvents = this.filterEvents(events, filter);

    return (
      <div>
        {this.modal(this.state.selectedEvent, options)}
        <Row>
          {/*<Col sm={2}>*/}
            {/*{JSON.stringify(this.state.filter)}*/}
            {/*<TagList tags={tags} visible={eventTags}/>*/}
          {/*</Col>*/}
          <Col sm={12}>
            {/*<div style={{marginBottom: 10}}>*/}
              {/*<DaySelector />*/}
              {/*{" "}*/}
              {/*<ViewSelector />*/}
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
                date={date}
                view={view}
                events={filteredEvents}
                startAccessor='startsOn'
                endAccessor='endsOn'
                titleAccessor='summary'
                views={['month','week','work_week','day','agenda']}
                popup
                eventPropGetter={eventPropGetter}
                onNavigate={this.onNavigate}
                onView={this.onView}
                defaultDate={date}
                selectable
                onSelectEvent={this.handleSelectEvent}
                onRangeChange={this.onRangeChange}
                min={min}
              />
            </div>
          </Col>
        </Row>
      </div>
    );
  }
}

interface DaySelectorProps {

}

const EventView: React.SFC<{event: Event}> = ({ event }) => {
  return (
    <div>Boom!</div>
  );
}

const DaySelector: React.SFC<DaySelectorProps> = (props) => {
  return (
    <div className="btn-group" role="group" >
      <button type="button" className="btn btn-default">Today</button>
      <button type="button" className="btn btn-default">Back</button>
      <button type="button" className="btn btn-default">Next</button>
    </div>
  )
}

interface ViewSelectorProps {

}

const ViewSelector: React.SFC<ViewSelectorProps> = (props) => {
  return (
    <div className="btn-group" role="group" >
      <button type="button" className="btn btn-default">Month</button>
      <button type="button" className="btn btn-default">Week</button>
      <button type="button" className="btn btn-default">Work Week</button>
      <button type="button" className="btn btn-default">Day</button>
      <button type="button" className="btn btn-default">Agenda</button>
    </div>
  )
}


interface Filter {
  tags: string;
}


// interface TagListProps {
//   tags: TagMap;
//   visible: Set<string>;
// }
//
// const TagList: React.SFC<TagListProps> = (props) => {
//   const keys = Object.keys(props.tags).filter(key => props.visible.has(key));
//   if (keys.length == 0) { return <div/>; }
//   const tags = keys.map(key => props.tags[key]);
//   return (
//     <div className="list-group">
//       {tags.map(tag => (
//         <div className="list-group-item" key={tag.id} style={{ backgroundColor: tag.color }}>
//           {tag.name}
//         </div>
//       ))}
//     </div>
//   )
// }

export default withRouter(Calendar);

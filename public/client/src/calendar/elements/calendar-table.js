import { bindable, containerless, computedFrom } from 'aurelia-framework';
import moment                                    from 'moment';

let _rows = [];

@containerless
export class CalendarTable {

  @bindable date;
  @bindable startDate;
  @bindable endDate;
  @bindable events;
  @bindable programs;

  attached() {

  }

  @computedFrom('startDate', 'endDate', 'events')
  get rows() {
    let next = moment(this.startDate).clone();
    _rows = [];
    while(next.isSameOrBefore(this.endDate)) {
      let end = next.clone().add(6, 'days');
      if(end.isAfter(this.endDate)) {
        end = moment(this.endDate);
      }
      let row = {
        start: next.format('MM-DD-YYYY'),
        end: end.format('MM-DD-YYYY'),
        events: this.eventsBetween(next, end)
      };
      _rows.push(row);
      next.add(7, 'days');      
    }
    return _rows;    
  }

  eventsBetween(start, end) {
    return this.events.filter((event) => {
      return moment(event.startsOn).isBetween(start, end);
    });
  }

}

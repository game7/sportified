import { bindable, containerless } from 'aurelia-framework';
import moment                      from 'moment';

@containerless
export class CalendarTableRow {

  @bindable startDate;
  @bindable endDate
  @bindable date;
  @bindable events;

  attached() {
    let date = moment(this.startDate).clone();
    this.days = [];
    while(date.isSameOrBefore(this.endDate)) {
      this.days.push({
        date: date.format('YYYY-MM-DD'),
        events: this.eventsForDate(date)
      });
      date.add(1, 'days');
    }
    this.dayWidth = `${((1/this.days.length)*100).toFixed(2)}%`
  }

  eventsForDate(date) {
    return this.events.filter((event) => {
      return moment(event.starts_on).isSame(date, 'day');
    })
  }

}

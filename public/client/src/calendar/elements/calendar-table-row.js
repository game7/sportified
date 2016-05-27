import { bindable, containerless } from 'aurelia-framework';
import moment                      from 'moment';

@containerless
export class CalendarTableRow {

  @bindable startDate;
  @bindable endDate
  @bindable date;

  attached() {
    let date = moment(this.startDate).clone();
    this.days = [];
    while(date.isSameOrBefore(this.endDate)) {
      this.days.push(date.format('YYYY-MM-DD'));
      date.add(1, 'days');
    }
  }

}

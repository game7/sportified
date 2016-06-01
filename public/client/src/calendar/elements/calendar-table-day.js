import { bindable, containerless, computedFrom } from 'aurelia-framework';
import moment                                    from 'moment';

@containerless
export class CalendarTableDay {

  @bindable date;
  @bindable width;
  @bindable events;
  @bindable programs;

  attached() {
    this.isToday = (moment(this.date).format("MM-DD-YYYY") == moment().format("MM-DD-YYYY"));
    this.day = moment(this.date).format('D');
  }

}

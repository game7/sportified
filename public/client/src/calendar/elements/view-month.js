import { bindable, computedFrom } from 'aurelia-framework';
import moment                     from 'moment';

export class ViewMonth {

  @bindable date;

  attached() {
    this.title = moment(this.date).format('MMMM YYYY')
  }

  @computedFrom('date')
  get startDate() {
    return this.firstDateOfWeek(this.firstDateOfMonth(this.date));
  }

  @computedFrom('date')
  get endDate() {
    return this.lastDateOfWeek(this.lastDateOfMonth(this.date));
  }

  firstDateOfMonth(date) {
    return moment(date).clone().startOf('month');
  }

  firstDateOfWeek(date) {
    return moment(date).clone().startOf('week');
  }

  lastDateOfMonth(date) {
    return moment(date).clone().endOf('month');
  }

  lastDateOfWeek(date) {
    return moment(date).clone().endOf('week');
  }

}

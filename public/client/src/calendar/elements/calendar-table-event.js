import { bindable, computedFrom } from 'aurelia-framework';
import moment                     from 'moment';

export class CalendarTableEventCustomElement {

  @bindable event;

  @computedFrom('event.starts_on')
  get time() {
    return moment(this.event.starts_on).utc().format("h:mma").replace('m','');
  }

  @computedFrom('event.duration')
  get height() {
    return `${this.event.duration}px`;
  }

}

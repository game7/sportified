import { bindable } from 'aurelia-framework'
import moment       from 'moment'

export class CalendarDateStepperCustomElement {

    @bindable date;
    @bindable view;
    @bindable onStep;

    back() {
      this.step(-1, 'months');
    }

    today() {
      let date = moment().format('MM-DD-YYYY')
      if(this.onStep) {
        this.onStep({ date: date });
      }
    }

    forward() {
      this.step(1, 'months');
    }

    step(number, unit) {
      let date = moment(this.date).add(number, unit).format('MM-DD-YYYY');
      if(this.onStep) {
        this.onStep({ date: date });
      }
    }

}

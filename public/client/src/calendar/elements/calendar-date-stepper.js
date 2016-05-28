import { bindable } from 'aurelia-framework'
import moment       from 'moment'

export class CalendarDateStepperCustomElement {

    @bindable date;
    @bindable stepAmount;
    @bindable stepUnit;
    @bindable onStep;

    back() {
      this.step(-this.stepAmount, this.stepUnit);
    }

    today() {
      let date = moment().format('MM-DD-YYYY')
      if(this.onStep) {
        this.onStep({ date: date });
      }
    }

    forward() {
      this.step(this.stepAmount, this.stepUnit);
    }

    step(number, unit) {
      let date = moment(this.date).add(number, unit).format('MM-DD-YYYY');
      if(this.onStep) {
        this.onStep({ date: date });
      }
    }

}

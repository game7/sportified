import { bindable, containerless, computedFrom } from 'aurelia-framework';
import moment                                    from 'moment';

let _rows = [];

@containerless
export class CalendarTable {

  @bindable date;
  @bindable startDate;
  @bindable endDate

  attached() {

  }

  @computedFrom('startDate', 'endDate')
  get rows() {
    let next = moment(this.startDate).clone();
    _rows = [];
    while(next.isSameOrBefore(this.endDate)) {
      let end = next.clone().add(6, 'days');
      if(end.isAfter(this.endDate)) {
        end = moment(this.endDate);
      }
      _rows.push({
        start: next.format('MM-DD-YYYY'),
        end: end.format('MM-DD-YYYY')
      });
      next.add(7, 'days');      
    }
    console.log('rows', _rows.length);
    return _rows;    
  }

}

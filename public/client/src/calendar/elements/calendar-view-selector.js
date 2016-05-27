import { bindable } from 'aurelia-framework';

export class CalendarViewSelectorCustomElement {

  @bindable viewName;
  @bindable onSelect;

  views = [
    {
      name: 'day',
      label: 'Day'
    },
    {
      name: 'four',
      label: '4 Day'
    },
    {
      name: 'week',
      label: 'Week'
    },
    {
      name: 'month',
      label: 'Month'
    }
  ]

  select(viewName) {
    if(this.onSelect) {
      this.onSelect({ viewName: viewName });
    }
  }

}

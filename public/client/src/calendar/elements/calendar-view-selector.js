import { bindable } from 'aurelia-framework';

export class CalendarViewSelectorCustomElement {

  @bindable viewName;
  @bindable onSelect;

  select(viewName) {
    if(this.onSelect) {
      this.onSelect({ viewName: viewName });
    }
  }

}

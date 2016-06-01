import { bindable, computedFrom, inject } from 'aurelia-framework';
import moment                     from 'moment';
import _                          from 'lodash';

import $ from 'jquery';
import 'bootstrap';

@inject(Element)
export class CalendarTableEventCustomElement {

  @bindable event;
  @bindable programs;

  constructor(Element) {
    this.element = Element
  }

  @computedFrom('event.startsOn')
  get start() {
    return moment(this.event.startsOn).utc().format('M/D/YY h:mm A');
  }

  @computedFrom('event.startsOn', 'event.duration')
  get end() {
    return moment(this.event.startsOn).add(this.event.duration, 'minutes').utc().format('M/D/YY h:mm A');
  }  

  @computedFrom('event.duration')
  get height() {
    return `${this.event.duration}px`;
  }

  @computedFrom('program.color') 
  get color() {
    return _.get(this, 'program.color', '#CCC');
  }

  attached() {
    this.findProgram();
    this.configurePopover();
  }

  findProgram() {
    if(this.programs && this.event) {
      let self = this;
      this.program = this.programs.find((program) => {
        return program.id == self.event.programId;
      });
    }    
  }

  configurePopover() {
    let $template = $(this.element).find('.popover-template').html();
    $(this.element).find('a').popover({
      template: $template,
      title: this.event.summary,
      trigger: 'focus',
      placement: 'auto right'
    });
  }

}

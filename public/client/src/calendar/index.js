import moment                   from 'moment';
import { inject, computedFrom } from 'aurelia-framework';
import { Router }               from 'aurelia-router';

@inject(Router)
export class Index {

  constructor(router) {
    this.router = router;
  }

  activate(params) {
    this.date = moment(params.date).format('MM-DD-YYYY');
    this.view = params.view || 'month';
  }

  setDate(date) {
    let formatted = moment(date).format('MM-DD-YYYY');
    this.router.navigateToRoute('calendar/index', { date: formatted, view: this.view });
    this.date = formatted;   
  }

  setView(viewName) {
    this.router.navigateToRoute('calendar/index', { date: this.date, view: viewName });
    this.view = viewName;
  }

  @computedFrom('date', 'view')
  get startDate() {
    switch(this.view) {
      case 'day':
        return this.date;
        break;
      case 'four':
        return moment(this.date).subtract(1, 'days').format('MM-DD-YYYY');
        break;
      case 'week':
        return this.firstDateOfWeek(this.date).format('MM-DD-YYYY');
        break;
      case '':
      case 'month':
        return this.firstDateOfWeek(this.firstDateOfMonth(this.date)).format('MM-DD-YYYY');
        break;
    }
  }

  @computedFrom('date', 'view')
  get endDate() {
    switch(this.view) {
      case 'day':
        return this.date;
        break;
      case 'four':
        return moment(this.date).add(2, 'days').format('MM-DD-YYYY');
        break;
      case 'week':
        return this.lastDateOfWeek(this.date).format('MM-DD-YYYY');
        break;
      case '':
      case 'month':
        return this.lastDateOfWeek(this.lastDateOfMonth(this.date)).format('MM-DD-YYYY');
        break;    
    }
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

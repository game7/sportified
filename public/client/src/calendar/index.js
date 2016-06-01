import moment                   from 'moment';
import { inject, computedFrom } from 'aurelia-framework';
import { Router }               from 'aurelia-router';
import { Resource }             from '../framework/resource';
import { Store }                from '../framework/store';
import { bind }                 from 'lodash';

@inject(Router)
export class Index {

  constructor(router) {
    this.router = router;
    this.events = [];
    this.programs = [];
  }

  activate(params) {
    this.date = moment(params.date).format('MM-DD-YYYY');
    this.view = params.view || 'month';
    
    let promises = [];
    
    promises.push(this.loadEvents(this.date).then(() => {
      this.loadViewSettings();
    }));

    promises.push(Resource.all('program').then((programs) => {
      this.programs = programs;
    }));

    return Promise.all(promises);

  }

  setDate(date) {
    let formatted = moment(date).format('MM-DD-YYYY');
    this.router.navigateToRoute('calendar/index', { date: formatted, view: this.view });
    this.date = formatted;  
    return this.loadEvents(date).then(() => {
      this.loadViewSettings();
    });
  }

  setView(viewName) {
    this.router.navigateToRoute('calendar/index', { date: this.date, view: viewName });
    this.view = viewName;
    this.loadViewSettings();
  }

  loadEvents(date) {
    let event = this.events[0];
    if (event && moment(date).isSame(event.starts_on, 'month')) {
      return Promise.all([]);
    }
    const start = this.firstDateOfMonth(date).format('YYYY-MM-DD');
    const end = this.lastDateOfWeek(date).format('YYYY-MM-DD');
    let self = this;
    return Store.current.api.all('event').get({ 
      from: start,
      to: end,
      include: 'program',
    }).then((events) => {
      this.events = events; 
    })
  }

  loadViewSettings() {
    const settings = {
      day: this.loadDayViewSettings,
      four: this.loadFourViewSettings,
      week: this.loadWeekViewSettings,
      month: this.loadMonthViewSettings      
    }
    if(settings[this.view]) {
      bind(settings[this.view], this)();      
    }
  }

  loadDayViewSettings() {
    this.startDate  = this.date;
    this.endDate    = this.date;
    this.stepAmount = 1;
    this.stepUnit   = 'days';
  }

  loadFourViewSettings() {
    this.startDate  = moment(this.date).subtract(1, 'days').format('MM-DD-YYYY');
    this.endDate    = moment(this.date).add(2, 'days').format('MM-DD-YYYY');
    this.stepAmount = 4;
    this.stepUnit   = 'days';
  }    

  loadWeekViewSettings() {
    this.startDate  = this.firstDateOfWeek(this.date).format('MM-DD-YYYY');
    this.endDate    = this.lastDateOfWeek(this.date).format('MM-DD-YYYY');
    this.stepAmount = 7;
    this.stepUnit   = 'days';
  }  

  loadMonthViewSettings() {
    this.startDate  = this.firstDateOfWeek(this.firstDateOfMonth(this.date)).format('MM-DD-YYYY');
    this.endDate    = this.lastDateOfWeek(this.lastDateOfMonth(this.date)).format('MM-DD-YYYY');
    this.stepAmount = 1;
    this.stepUnit   = 'months';
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

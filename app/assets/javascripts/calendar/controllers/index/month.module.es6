import Ember from 'ember';

export default Ember.Controller.extend({
  indexController: Ember.inject.controller('index'),
  events: Ember.computed.reads('indexController.model'),
	date: Ember.computed.reads('indexController.date'),

  month: Ember.computed('date', function() {
    return moment(this.get('date')).format('MMMM');
  }),

  year: Ember.computed('date', function() {
    return moment(this.get('date')).year();
  }),

  eventsByDay: Ember.computed('date', 'events', function() {
    let result = {},
        date = this.get('date'),
        events = this.get('events') || [];
    events.filter((event) => moment(event.starts_on).isSame(date, 'month')).forEach((event) => {
      let day = moment(event.starts_on).date();
      result[day] = result[day] || [];
      result[day].push(event);
    })
    return result;
  }),

	daysByWeek: Ember.computed('date', function() {
    
    let date = moment(this.get('date')),
      firstDayOfMonth = date.date(1).isoWeekday(),
      days = [],
      weeks = [],
      events = this.get('eventsByDay');

    // pad first week to account for day of week
    for(let i = 1; i < firstDayOfMonth; i++) {
      days.push(null);
    }

    // add all dates in month
    for(var i = 0; i < date.daysInMonth(); i++) {
      days.push({
        number: i + 1,
        events: events[i+1] || []
      });
    }

    // create array of weeks
    while(days.length > 0) {
      weeks.push(days.splice(0, 7));
    }

    // ensure last week has 7 positions
    let lastWeek = weeks[weeks.length - 1];
    while(lastWeek.length < 7) {
      lastWeek.push(null);
    }

    return weeks;

	}),

	actions: {

	}

});
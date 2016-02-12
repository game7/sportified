import Ember from 'ember';

export default Ember.Controller.extend({
  indexController: Ember.inject.controller('index'),
	date: Ember.computed.reads('indexController.date'),

	daysByWeek: Ember.computed('daysByMonth', function() {
    
    let date = moment(this.get('date')),
      firstDayOfMonth = date.date(1).isoWeekday(),
      days = [],
      weeks = [];

    // pad first week to account for day of week
    for(let i = 1; i < firstDayOfMonth; i++) {
      days.push(null);
    }

    // add all dates in month
    for(var i = 0; i < date.daysInMonth(); i++) {
      days.push(i + 1);
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
import Ember from 'ember';
import moment from 'moment';

export default Ember.Controller.extend({

  queryParams: ['date'],

  month: Ember.computed('date', function() {
    return moment(this.get('date')).format('MMMM');
  }),

  year: Ember.computed('date', function() {
    return moment(this.get('date')).year();
  }),

  init: function() {
    let hours = [];
    for(var i = 8; i < 24; i++) {
      hours.push(i);
    }
    this.set('hours', hours);
  },

  eventsByDay: Ember.computed('date', 'events', function() {
    let result = {},
        events = this.get('events') || [];
    events.forEach((event) => {
      let day = moment(event.starts_on).date();
      result[day] = result[day] || [];
      result[day].push(event);
    });
    return result;
  }),

  days: Ember.computed('date', function() {

    let date = moment(this.get('date'));
    let start = date.clone().subtract(date.day(), 'days');
    let days = [];
    let events = this.get('eventsByDay');

    for(let i = 0; i < 7; i++) {
      days.push({
        date: start.format('YYYY-MM-DD'),
        events: events[start.date()] || []
      });
      start.add(1,'days');
    }
    return days;

  }),

  actions: {}

});

import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    date: {
      refreshModel: true
    }
  },
  model() {
    return sportified.events.map((event) => {
    	event.starts_on = moment(event.starts_on).add(7, 'h').toISOString();
    	event.ends_on = moment(event.ends_on).add(7, 'h').toISOString();
      return event;
    });
  }
});
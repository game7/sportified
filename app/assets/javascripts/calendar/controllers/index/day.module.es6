import Ember from 'ember';

export default Ember.Controller.extend({
  date: Ember.computed.reads('queryParams.date'), 
  init: function() {
    let hours = [];
    for(var i = 8; i < 24; i++) {
      hours.push(i);
    }
    this.set('hours', hours);  
  },
	actions: {
	}
});
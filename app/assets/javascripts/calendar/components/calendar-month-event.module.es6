import Ember from 'ember'

export default Ember.Component.extend({
  classNames: ['event'],
  time: Ember.computed('event.starts_on', function() {
  	return moment(this.get('event.starts_on')).format('h:mm A');
  }),
  actions: {}
});
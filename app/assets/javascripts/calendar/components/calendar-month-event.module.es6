import Ember from 'ember'

export default Ember.Component.extend({
  classNames: ['event'],
  init: function() {
  	this._super();
  	let event = this.get('event'),
  		time = moment(event.starts_on).format('h:mm A');
  	this.set('time', time);
  },
  didInsertElement: function() {
  	this.$().find('a[rel=popover]').popover().click(function(e) {
  		e.preventDefault();
  	});
  },
  willDestroyElement: function() {
  	this.$().find('a[rel=popover]').popover('destroy');
  },
  actions: {}
});
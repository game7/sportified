import Ember from 'ember'

export default Ember.Component.extend({
  today: moment().format('L'),
  nextDate: Ember.computed('date', function() {
    return moment(this.get('date')).add(1,'month').format('L')
  }),
  prevDate: Ember.computed('date', function() {
    return moment(this.get('date')).subtract(1,'month').format('L')
  }),
  actions: {

  }
});
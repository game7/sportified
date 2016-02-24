import Ember from 'ember';
import moment from 'moment';

export default Ember.Component.extend({
  today: moment().format('YYYY-MM-DD'),
  nextDate: Ember.computed('date', function() {
    return moment(this.get('date')).add((this.get('quantity') || 1), this.get('interval')).format('YYYY-MM-DD');
  }),
  prevDate: Ember.computed('date', function() {
    return moment(this.get('date')).subtract((this.get('quantity') || 1), this.get('interval')).format('YYYY-MM-DD');
  }),
  actions: {}
});

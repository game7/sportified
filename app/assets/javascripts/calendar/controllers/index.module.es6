import Ember from 'ember';

export default Ember.Controller.extend({
  date: moment().format('L'),
  actions: {}
});
import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    date: {
      refreshModel: true
    }
  },
  beforeModel() {
    //this.transitionTo('index.day');
  }
});
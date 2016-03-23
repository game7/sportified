import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.store.peekRecord('hockey/goal', params.goal_id);
  },
});

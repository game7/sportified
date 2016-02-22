import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.query('game', { days: 7 })
  },
  setupController: function(controller, model) {
    controller.set('games', model);
  }
});

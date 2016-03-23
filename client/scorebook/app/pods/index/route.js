import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.query('game', { days: 21 });
  },
  setupController: function(controller, model) {
    controller.set('games', model);
  }
});

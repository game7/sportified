import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.store.find('game', params.game_id);
  },
  setupController: function(controller, model) {
    controller.set('game', model);
  }
});

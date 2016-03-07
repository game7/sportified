import Ember from 'ember';

export default Ember.Controller.extend({
  gameController: Ember.inject.controller("game"),
  game: Ember.computed.reads('gameController.game'),
  count: 5,
  actions: {
    up() {
      this.incrementProperty('count')
    },
    down() {
      this.decrementProperty('count');
    }
  }
});

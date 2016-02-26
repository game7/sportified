import Ember from 'ember';

export default Ember.Controller.extend({
  gameController: Ember.inject.controller("game"),
  game: Ember.computed.reads('gameController.game')
});

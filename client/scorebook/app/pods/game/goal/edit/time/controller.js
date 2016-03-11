import Ember from 'ember';

export default Ember.Controller.extend({
  gameController: Ember.inject.controller("game"),
  game: Ember.computed.reads('gameController.game'),
  editController: Ember.inject.controller("game/goal/edit"),
  time: Ember.computed.reads('editController.time'),
  actions: {
    setTime: function(time) {
      this.get('editController').send('setTime', time);
    }
  }
});

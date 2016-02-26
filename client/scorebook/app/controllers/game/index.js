import Ember from 'ember';

const {
  computed
} = Ember;

export default Ember.Controller.extend({

  gameController: Ember.inject.controller("game"),
  game: Ember.computed.reads('gameController.game'),
  clock: Ember.computed.reads('gameController.clock'),

  label: computed('clock.ticking', function() {
    const ticking = this.get('clock.ticking');
    return ticking ? 'Stop' : 'Start';
  }),

  actions: {
    toggleClock: function() {
      this.get('clock').toggle();
    }
  }

});

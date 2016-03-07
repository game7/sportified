import Ember from 'ember';

const {
  computed
} = Ember;

export default Ember.Controller.extend({

  gameController: Ember.inject.controller("game"),

  game: Ember.computed.reads('gameController.game'),
  statsheet: Ember.computed.reads('gameController.statsheet'),
  homeTeam: Ember.computed.reads('gameController.homeTeam'),
  awayTeam: Ember.computed.reads('gameController.awayTeam'),

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

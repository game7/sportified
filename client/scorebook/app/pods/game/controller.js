import Ember from 'ember';

export default Ember.Controller.extend({

  init(params) {
    this._super(params);
    this.set('clock.ticks', 20 * 60 * 1000);
    console.log('game controller init');
  },

  game: Ember.computed.alias('model.game'),
  statsheet: Ember.computed.alias('model.statsheet'),
  homeTeam: Ember.computed.alias('model.homeTeam'),
  awayTeam: Ember.computed.alias('model.awayTeam'),

  clock: Ember.inject.service()

});

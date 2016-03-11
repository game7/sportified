import Ember from 'ember';

export default Ember.Controller.extend({

  gameController: Ember.inject.controller("game"),
  game: Ember.computed.reads('gameController.game'),

  editController: Ember.inject.controller("game/goal/edit"),
  selectedTeam: Ember.computed.reads('editController.team'),
  time: Ember.computed.reads('editController.time'),
  goal: Ember.computed.reads('editController.goal'),

  homeTeam: Ember.computed.reads('game.homeTeam'),
  awayTeam: Ember.computed.reads('game.awayTeam'),

  homeTeamSelected: Ember.computed('selectedTeam', 'homeTeam', function(){
    return this.get('selectedTeam.id') == this.get('homeTeam.id');
  }),

  awayTeamSelected: Ember.computed('selectedTeam', 'awayTeam', function(){
    return this.get('selectedTeam.id') == this.get('awayTeam.id');
  }),

  setTeam(team) {
    this.set('selectedTeam', team);
    this.get('editController').send('setTeam', team);
  },

  actions: {
    selectHomeTeam: function() {
      this.setTeam(this.get('homeTeam'));
    },
    selectAwayTeam: function() {
      this.setTeam(this.get('awayTeam'));
    }
  }

});

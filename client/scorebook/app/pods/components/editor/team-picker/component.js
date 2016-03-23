import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['team-picker'],

  homeTeam: Ember.computed.reads('game.homeTeam'),
  awayTeam: Ember.computed.reads('game.awayTeam'),

  homeTeamSelected: Ember.computed('selected', 'homeTeam', function computeHomeTeamSelected(){
    return this.get('selected.id') == this.get('homeTeam.id');
  }),

  awayTeamSelected: Ember.computed('selected', 'awayTeam', function computeAwayTeamSelected(){
    return this.get('selected.id') == this.get('awayTeam.id');
  }),

  actions: {
    selectHomeTeam: function selectHomeTeam() {
      this.get('onSelection')(this.get('homeTeam'));
    },
    selectAwayTeam: function selectAwayTeam() {
      this.get('onSelection')(this.get('awayTeam'));
    }
  }

});

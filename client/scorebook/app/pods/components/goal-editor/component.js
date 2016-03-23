import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['goal-editor'],

  time: Ember.computed.oneWay('goal.time'),
  team: Ember.computed.oneWay('goal.team'),
  scoredBy: Ember.computed.oneWay('goal.scoredBy'),
  assistedBy: Ember.computed.oneWay('goal.assistedBy'),
  alsoAssistedBy: Ember.computed.oneWay('goal.alsoAssistedBy'),

  teamSkaters: Ember.computed('team', function computeTeamSkaters() {
    return this.get('statsheet.skaters').filterBy('team.id', this.get('team.id'));
  }),

  actions: {

    setTime: function setTime(time) {
      this.set('time', time);
    },

    setTeam: function setTeam(team) {
      if(this.get('team.id') !== team.get('id')) {
        this.set('scoredBy', null);
        this.set('assistedBy', null);
        this.set('alsoAssistedBy', null);
        this.set('team', team);
      }
    },

    setScoredBy: function setScoredBy(skater) {
      this.set('scoredBy', skater);
    },

    setAssistedBy: function setAssistedBy(skater) {
      this.set('assistedBy', skater);
    },

    setAlsoAssistedBy: function setAlsoAssistedBy(skater) {
      this.set('alsoAssistedBy', skater);
    },

    submit: function () {
      this.sendAction('onSubmit', {
        time: this.get('time'),
        team: this.get('team'),
        scoredBy: this.get('scoredBy'),
        assistedBy: this.get('assistedBy'),
        alsoAssistedBy: this.get('alsoAssistedBy')
      });
    }
  }

});

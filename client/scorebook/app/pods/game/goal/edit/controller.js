import Ember from 'ember';
import moment from 'moment';

export default Ember.Controller.extend({

  gameController: Ember.inject.controller("game"),
  game: Ember.computed.reads('gameController.game'),

  time: Ember.computed.oneWay('goal.time'),
  team: Ember.computed.oneWay('goal.team'),

  formattedTime: Ember.computed('time', function() {
    return moment(this.get('time')._data).format("m:ss");
  }),

  actions: {
    setTime: function(time) {
      this.set('time', time);
    },
    setTeam: function(team) {
      this.set('team', team);
    },
    update: function(data) {
      let goal = this.get('goal');
      const time = this.get('time');
      goal.update({
        minute: time.minutes(),
        second: time.seconds()
      }).then(function(a, b, c) {

      }, function(a, b, c) {
        console.log(goal.errors);
      });
    }
  }

});

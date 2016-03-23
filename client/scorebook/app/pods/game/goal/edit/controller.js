import Ember from 'ember';
import moment from 'moment';

export default Ember.Controller.extend({
  queryParams: ['tab'],

  goal: Ember.computed.alias('model'),

  gameController: Ember.inject.controller("game"),
  game: Ember.computed.reads('gameController.game'),
  statsheet: Ember.computed.reads('gameController.statsheet'),

  actions: {
    update: function(data) {
      let goal = this.get('goal');
      goal.setProperties(data);
      goal.save().then(
        () => {
          this.transitionToRoute('game.index', this.get('game.id'));
        },
        () => {
          console.log(goal.errors);
          goal.rollbackAttributes();
        }
      );
    }
  }

});

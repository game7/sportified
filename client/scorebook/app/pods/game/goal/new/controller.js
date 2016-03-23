import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: ['tab', 'teamId'],

  goal: Ember.computed.alias('model'),

  gameController: Ember.inject.controller("game"),
  game: Ember.computed.reads('gameController.game'),
  statsheet: Ember.computed.reads('gameController.statsheet'),

  actions: {
    create: function(data) {
      let goal = this.store.createRecord('hockey/goal', data);
      goal.set('statsheet', this.get('statsheet'));
      goal.set('period', 1);
      goal.save().then(
        () => {
          this.transitionToRoute('game.index', this.get('game.id'));
        },
        (response) => {
          console.log(response.errors);
          goal.rollbackAttributes();
        }
      );
    }
  }

});

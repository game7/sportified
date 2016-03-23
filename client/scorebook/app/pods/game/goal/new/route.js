import Ember from 'ember';

export default Ember.Route.extend({

  clock: Ember.inject.service('clock'),

  model(params) {
    let goal = Ember.Object.create({
      statsheet: this.modelFor('game').statsheet,
      team: this.store.peekRecord('team', params.teamId),
      time: this.get('clock.time')
    });
    console.log(goal);
    return goal;
  }

});

import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    // const game = this.store.find('game', params.game_id);
    // debugger;
    // return Ember.RSVP.hash({
    //   homeTeam: game.homeTeam,
    //   awayTeam: game.awayTeam
    // })
  },
  setupController: function(controller, model) {
    // controller.set('homeTeam', model.homeTeam);
    // controller.set('awayTeam', model.awayTeam);
  }
});

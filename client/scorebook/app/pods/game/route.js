import Ember from 'ember';
import Statsheet from 'scorebook/models/statsheet';

export default Ember.Route.extend({
  model(params) {
    const store = this.store;
    return store.find('game', params.game_id).then(function(game) {
      return game.statify().then(function(payload) {
        store.pushPayload('game', payload);
        return Ember.RSVP.hash({
          game: game,
          statsheet: game.get('statsheet'),
          homeTeam: game.get('homeTeam'),
          awayTeam: game.get('awayTeam')
        })
      })
    });
  },
  setupController: function(controller, model) {
    if(!controller.get('game')) {
      controller.set('game', model.game);
    }
    if(!controller.get('statsheet')){
      controller.set('statsheet', model.statsheet);
    }
    if(!controller.get('homeTeam')){
      controller.set('homeTeam', model.homeTeam);
    }
    if(!controller.get('awayTeam')){
      controller.set('awayTeam', model.awayTeam);
    }
  }
});

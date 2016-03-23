import Ember from 'ember';

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
        });
      });
    });
  }
});

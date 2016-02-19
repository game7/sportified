// For more information see: http://emberjs.com/guides/routing/

import Ember from 'ember';

var Router = Ember.Router.extend({
  enableLogging: true,
  // location: 'history'
});

Router.map(function() {
  this.route('game', { path: '/game/:game_id' });
});

export default Router;

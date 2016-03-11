import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('game', { path: '/game/:game_id' }, function() {
    this.route('goal', function() {
      this.route('new');
      this.route('edit', { path: '/edit/:goal_id'}, function() {
        this.route('scoredBy');
        this.route('time');
        this.route('assistedBy');
        this.route('alsoAssistedBy');
        this.route('team');
      });
    });

    this.route('penalty', function() {
      this.route('new');
    });
  });
});

export default Router;

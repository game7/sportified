import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('index', { path: '/' }, function() {
    this.route('day');
    this.route('week');
    this.route('month');
  });
  this.route('about');
});

export default Router;

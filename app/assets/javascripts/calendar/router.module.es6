// For more information see: http://emberjs.com/guides/routing/

import Ember from 'ember';

var Router = Ember.Router.extend({
  enableLogging: true,
  // location: 'history'
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

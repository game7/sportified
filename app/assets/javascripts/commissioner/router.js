// For more information see: http://emberjs.com/guides/routing/

Sportified.Router.map(function() {
    // @resource('posts')
});

Sportified.IndexRoute = Ember.Route.extend({
  model: function() {
    return ['red', 'yellow', 'blue'];
  }
});



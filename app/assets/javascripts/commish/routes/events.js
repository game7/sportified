App.EventsRoute = Ember.Route.extend({
  model: function(params) {
    var events = this.store.findAll('event');
    return events;
  },
  setupController: function(controller, model) {
    controller.set('model', model)
  }
})
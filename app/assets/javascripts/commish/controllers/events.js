App.EventsController = App.Calendar.CalendarController.extend({
  states: ['day','week'],
  update: function() {
    var self = this;
    /*
    this.store.findAll('event').then(function(result) {
      self.clear().pushObjects(result.content);
    });
    */
  }.observes('week'),
  init: function() {
    this.set('initialDate', '2/25/2014');
    this.set('initialState', 'week')
    this._super();
    var self = this;
    this.store.findAll('event').then(function(result) {
      self.clear().pushObjects(result.content);
    });    
  }
})
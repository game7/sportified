import Ember from 'ember';

export default Ember.Route.extend({

  queryParams: {
    date: {
      refreshModel: true
    }
  },

  model(params) {
    let date = moment(params.date);
    return $.get('/api/events', {
      from: date.format('YYYY-MM-DD'),
      to: date.add(1, 'days').format('YYYY-MM-DD')
    });
  },

  setupController: function(controller, model) {
    controller.set('events', model.events);
  },

  renderTemplate: function() {
    this.render();
    this.render('index/day-pager', {
      into: 'index',
      outlet: 'pager'
    })
  }

});

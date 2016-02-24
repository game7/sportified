import Ember from 'ember';
import moment from 'moment';
import $ from 'jquery';

export default Ember.Route.extend({

  queryParams: {
    date: {
      refreshModel: true
    }
  },

  model(params) {
    let date = moment(params.date);
    return $.get('/api/events', {
      from: date.clone().subtract(date.day(), 'days').format('YYYY-MM-DD'),
      to: date.clone().add(7 - date.day(), 'days').format('YYYY-MM-DD')
    });
  },

  setupController: function(controller, model) {
    controller.set('events', model.events);
  },

  renderTemplate: function() {
    this.render();
    this.render('index/week-pager', {
      into: 'index',
      outlet: 'pager'
    });
  }

});

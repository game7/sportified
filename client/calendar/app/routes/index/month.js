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
      from: date.clone().date(1).subtract(1, 'days').format('YYYY-MM-DD'),
      to: date.clone().date(1).add(1, 'months').format('YYYY-MM-DD')
    });
  },

  renderTemplate: function() {
    this.render();
    this.render('index/month-pager', {
      into: 'index',
      outlet: 'pager'
    });
  }

});

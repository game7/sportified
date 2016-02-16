import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    date: {
      refreshModel: true
    }
  },
  model(params) {
    let date = moment(params.date);
    return $.get({
      url: '/api/events/index',
      data: {
        from: date.format('YYYY-MM-DD'),
        to: date.add(1, 'days').format('YYYY-MM-DD')
      }
    })
  },
  renderTemplate: function() {
    this.render();
    this.render('index/day-pager', {
      into: 'index',
      outlet: 'pager'
    })
  }
});
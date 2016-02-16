import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    date: {
      refreshModel: true
    }
  },
  model(params) {
    let date = params.date || moment().format('YYYY-MM-DD');
    return sportified.events.filter(function(event) {
      return moment(event.starts_on).isSame(date, 'month');
    });
  },
  renderTemplate: function() {
    this.render();
    this.render('index/month-pager', {
      into: 'index',
      outlet: 'pager'
    })
  }
});
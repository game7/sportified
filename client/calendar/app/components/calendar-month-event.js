import Ember from 'ember'

export default Ember.Component.extend({
  classNames: ['event'],
  init: function() {
    this._super();
    let event = this.get('event'),
      start = moment(event.starts_on).format('h:mma').replace('m',''),
      end = moment(event.ends_on).format('h:mma').replace('m','');
  this.set('time', `${start} - ${end}`);
  },
  didInsertElement: function() {
    this.$().find('a[rel=popover]').popover({
      content: this.$().find('.event-popover').html(),
      html: true
    }).click(function(e) {
      e.preventDefault();
    });
  },
  willDestroyElement: function() {
    this.$().find('a[rel=popover]').popover('destroy');
  },
  actions: {}
});

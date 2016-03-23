import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['time-display'],
  formattedTime: Ember.computed('time', function() {
    const time = this.get('time');
    if (!time) { return ''; }
    return moment(this.get('time')._data).format("m:ss");
  }),
});

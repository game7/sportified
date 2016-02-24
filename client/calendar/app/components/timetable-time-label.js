import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'li',
  classNames: ['time-label'],
  init: function() {
    this._super();
    let hour = this.get('hour');
    if (hour > 12) {
      this.set('label', `${hour - 12} PM`);
    } else {
      this.set('label', `${hour} AM`);
    }
  }
})

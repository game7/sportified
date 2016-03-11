import Ember from 'ember';
import moment from 'moment';

export default Ember.Component.extend({
  init() {
    this._super(...arguments);
  },

  time: moment.duration(20, 'minutes'),

  actions: {
    onTimeChanged: function(amount, part) {
      this.get('onTimeChanged')(amount, part)
    }
  }

});

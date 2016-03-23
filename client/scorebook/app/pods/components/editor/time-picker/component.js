import Ember from 'ember';
import moment from 'moment';

export default Ember.Component.extend({
  init() {
    this._super(...arguments);
  },

  time: Ember.computed.oneWay('selected'),

  actions: {
    onTimeChanged: function(time) {
      this.get('onSelection')(time)
    }
  }

});

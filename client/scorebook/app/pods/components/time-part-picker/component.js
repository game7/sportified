import Ember from 'ember';
import NumericSpinner from '../numeric-spinner/component';
import moment from 'moment';

export default NumericSpinner.extend({

  layoutName: 'components/numeric-spinner',

  init: function() {
    this._super(...arguments);
  },

  //time: moment.duration(10, 'm'),

  step: 1,

  part: 's',

  add: function() {
    return moment.duration(this.get('time')).add(this.get('step'), this.get('part'));
  },

  subtract: function() {
    return moment.duration(this.get('time')).subtract(this.get('step'), this.get('part'));
  },

  value: Ember.computed('time', function() {

    const step = this.get('step');
    const timePart = this.get('time').get(this.get('part'));

    if (step === 1) {
      return timePart % 10;
    }
    return Math.floor(timePart / step);

  }),

  canUp: Ember.computed('time', function() {
    return this.add()._milliseconds <= moment.duration(20, 'm')._milliseconds;
  }),

  canDown: Ember.computed('time', function() {
    return this.subtract()._milliseconds >= 0;
  }),

  disableUp: Ember.computed('canUp', function() {
    return !this.get('canUp');
  }),

  disableDown: Ember.computed('canDown', function() {
    return !this.get('canDown');
  }),

  actions: {
    up: function() {
      this.set('time', this.add());
      this.get('onTimeChanged')(this.get('time'));
    },
    down: function() {
      this.set('time', this.subtract());
      this.get('onTimeChanged')(this.get('time'));
    }
  }

});

import Ember from 'ember';
import moment from 'moment';

const strlen = (int) => `${int}`.length < 2 ? `0${int}` : int;

const {
  observer,
  computed,
  run
} = Ember;

export default Ember.Service.extend({

  ticks: 0,
  ticking: false,

  time: computed('ticks', function computingTime() {
    return moment.duration(this.get('ticks'));
  }),

  minutes: computed('time', function computingMinutes() {
    return strlen(this.get('time').minutes());
  }),

  seconds: computed('time', function computingSeconds() {
    return strlen(this.get('time').seconds());
  }),

  tick: observer('ticking', function ticking() {
    run.later(() => {
      const ticking = this.get('ticking');
      if (ticking) {
        this.decrement();
        this.tick();
      }
    }, 1000);
  }),

  decrement() {
    const ticks = this.get('ticks');
    this.set('ticks', ticks - 1000);
  },

  start() {
    this.set('ticking', true);
  },

  stop() {
    this.set('ticking', false);
  },

  toggle() {
    this.toggleProperty('ticking');
  }

});

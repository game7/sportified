import Ember from 'ember';
import moment from 'moment';

const strlen = (int) => `${int}`.length < 2 ? `0${int}` : int;

const {
  observer,
  computed,
  run
} = Ember;

export default Ember.Object.extend({

  time: 0,
  ticking: false,

  minutes: computed('time', {
    get(key) {
      return strlen(moment.duration(this.get('time')).minutes());
    },
    set(key, value) {
      let duration = moment.duration(this.get('time'));
      this.set('time', duration.subtract(duration.minutes(), 'm').add(value, 'm').milliseconds());
    }
  }),

  seconds: computed('time', {
    get(key) {
      return strlen(moment.duration(this.get('time')).seconds());
    },
    set(key, value) {
      let duration = moment.duration(this.get('time'));
      this.set('time', duration.subtract(duration.seconds(), 's').add(value, 's').milliseconds());
    }
  }),

  tick: observer('ticking', function() {
    run.later(() => {
      const ticking = this.get('ticking');
      if (ticking) {
        this.decrement();
        this.tick();
      }
    }, 1000);
  }),

  decrement() {
    const time = this.get('time');
    this.set('time', time - 1000);
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

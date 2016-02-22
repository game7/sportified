import Ember from 'ember';
import Clock from 'scorebook/models/clock';

const {
  computed
} = Ember;

export default Ember.Controller.extend({

  init(params) {
    this._super(params);
    debugger;
    this.set('clock', Clock.create({ time: moment.duration(10, 'minutes').add(9, 'seconds') }));
  },

  label: computed('clock.ticking', function() {
    const ticking = this.get('clock.ticking');
    return ticking ? 'Stop' : 'Start';
  }),

  actions: {
    toggleClock: function() {
      this.get('clock').toggle();
    }
  }

})

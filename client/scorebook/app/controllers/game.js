import Ember from 'ember';
import Clock from 'scorebook/models/clock';

export default Ember.Controller.extend({

  init(params) {
    this._super(params);
    this.set('clock', Clock.create({ time: moment.duration(10, 'minutes').add(9, 'seconds') }));
  }

});

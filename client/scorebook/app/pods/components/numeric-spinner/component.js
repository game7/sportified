import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['btn-group-vertical'],
  attributeBindings: ['role', 'aria-label'],
  role: 'group',
  'aria-label': '...',

  init: function() {
    this._super(...arguments);
  },

  step: 1,

  value: 0,

  canUp: true,

  canDown: Ember.computed('value', 'step', function() {
    return (this.get('value') - this.get('step') >= 0);
  }),

  disableUp: Ember.computed('canUp', function() {
    return !this.get('canUp');
  }),

  disableDown: Ember.computed('canDown', function() {
    return !this.get('canDown');
  }),

  actions: {
    up() {
      this.get('onUp') ? this.get('onUp')() : this.incrementProperty('value', this.get('step'));
    },
    down() {
      this.get('onUp') ? this.get('onDown')() : this.decrementProperty('value', this.get('step'));
    }
  }

});

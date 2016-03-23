import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'button',
  classNames: ['btn', 'btn-default', 'btn-block', 'btn-lg'],
  classNameBindings: ['active'],
  active: Ember.computed('skater', 'selected', function computeActive() {
    return this.get('skater.id') === this.get('selected.id');
  }),
  click() {
    this.sendAction('onSelection', this.get('skater'));
  }
});

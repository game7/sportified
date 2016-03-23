import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'div',
  classnames: ['tab-content'],
  active: Ember.computed('selected', function computeTabContentActive() {
    return this.get('name') === this.get('selected');
  })
});

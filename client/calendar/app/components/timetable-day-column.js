import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'li',
  classNames: ['day-column'],
  attributeBindings: ['style'],
  style: function() {
    return `width: ${this.get('width')};`;
  }.property('width'),
  init: function() {
    this._super();
  }
})

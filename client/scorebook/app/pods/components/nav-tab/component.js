import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'li',
  attributeBindings: ['role'],
  role: 'presentation',
  childLinkViews: [],
  classNameBindings: ['active'],
  active: Ember.computed('childLinkViews.@each.active', function() {
    return Ember.A(this.get('childViews')).isAny('active');
  }),
  didRender: function() {
    Ember.run.schedule('afterRender', this, function() {
      var childLinkElements = this.$('a.ember-view');

      var childLinkViews = childLinkElements.toArray().map(view =>
        this._viewRegistry[view.id]
      );

      this.set('childLinkViews', childLinkViews);
    });
  }
});

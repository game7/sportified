import DS from 'ember-data';

export default DS.JSONAPISerializer.extend({
  keyForAttribute: function(attr, method) {
    return Ember.String.underscore(attr);
  },
  keyForRelationship: function(attr, method) {
    return Ember.String.underscore(attr);
  }
});

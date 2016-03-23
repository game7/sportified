import Ember from 'ember';

export default Ember.Component.extend({
  componentName: Ember.computed('model', function() {
    debugger;
    switch(this.get('model.constructor.modelName')) {
      case 'hockey/goal':
        return 'goal-list-item';
      case 'hockey/penalty':
        return 'penalty-list-item';
    }
    return '';
  })
});

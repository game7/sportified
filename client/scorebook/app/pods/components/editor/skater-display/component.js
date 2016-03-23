import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['team-display'],
  name: Ember.computed('skater', function() {
    const first = this.get('skater.firstName');
    const last = this.get('skater.lastName');
    if(first || last) {
      return `${first} ${last}`;
    }
    return '';
  })
});

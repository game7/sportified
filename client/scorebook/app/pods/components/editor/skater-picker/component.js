import Ember from 'ember';

export default Ember.Component.extend({

  actions: {
    select: function select(skater) {
      this.get('onSelection')(skater);
    }
  }

});

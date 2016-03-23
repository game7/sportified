import Ember from 'ember';
import sortArray from 'scorebook/utils/sort-array';

export default Ember.Component.extend({

  goals: Ember.computed.sort('statsheet.goals', sortArray(['period', 'minute', 'second'])),

});

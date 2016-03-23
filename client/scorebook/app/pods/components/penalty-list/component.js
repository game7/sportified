import Ember from 'ember';
import sortArray from 'scorebook/utils/sort-array';

export default Ember.Component.extend({

  penalties: Ember.computed.sort('statsheet.penalties', sortArray(['period', 'minute', 'second'])),

});

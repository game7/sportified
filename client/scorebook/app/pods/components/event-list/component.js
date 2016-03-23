import Ember from 'ember';
import DS from 'ember-data';
import sortArray from 'scorebook/utils/sort-array';

const {
  computed
} = Ember;

export default Ember.Component.extend({

  events: computed('statsheet.goals', 'statsheet.penalties', function() {
    let promise = this.get('statsheet.goals').then((goals) => {
      return this.get('statsheet.penalties').then((penalties) => {
        let events = goals.toArray().concat(penalties.toArray());
        events.sort(sortArray(['period', 'minute', 'second']));
        console.log(events);
        return events;
      })
    });
    return DS.PromiseArray.create({
      promise: promise
    });
    // return Ember.RSVP.hash({
    //   goals: this.get('statsheet.goals'),
    //   penalties: this.get('statsheet.penalties')
    // }).then(function(data) {
    //   let goals = data.goals.toArray();
    //   let penalties = data.penalties.toArray();
    //   let events = goals.concat(penalties);
    //   events.sort(sortArray(['period', 'minute', 'second']));
    //   console.log(events);
    //   return events;
    // });
  })
});

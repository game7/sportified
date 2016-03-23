import DS from 'ember-data';
import Ember from 'ember';
import buildOperationUrl from '../../utils/build-url';
import moment from 'moment';

const Goal = DS.Model.extend({
  period: DS.attr('string'),
  minute: DS.attr('number'),
  second: DS.attr('number'),
  scoredBy: DS.belongsTo('hockey/skater/result'),
  assistedBy: DS.belongsTo('hockey/skater/result'),
  alsoAssistedBy: DS.belongsTo('hockey/skater/result'),
  team: DS.belongsTo('team'),
  statsheet: DS.belongsTo('hockey/statsheet'),

  time: Ember.computed('period', 'minute', 'second', {
    get(key) {
      return moment.duration(this.get('minute'), 'm').add(this.get('second'), 's');
    },
    set(key, value) {
      this.set('minute', value.minutes());
      this.set('second', value.seconds());
      return value;
    }
  }),

  formattedTime: Ember.computed('time', function() {
    return moment(this.get('time')._data).format("m:ss");
  }),

  // update: memberAction({ path: ''} ),

  // update: function(payload) {

  //   let options = { path: '' };
  //   const modelName = this.constructor.modelName || this.constructor.typeKey;
  //   let requestType = options.type || 'PUT';
  //   let adapter = this.store.adapterFor(modelName);
  //   let fullUrl = buildOperationUrl(this, options.path, requestType);
  //   return adapter.ajax(fullUrl, requestType, Ember.$.extend(options.ajaxOptions || {}, { data: payload }));
  // }

  update: function(props) {
    this.setProperties(props);
    return this.save();
  }

});

Goal.reopenClass({
  create: function(props) {
    return this.store.createRecord('hockey/goal', props).save();
  }
})

export default Goal;

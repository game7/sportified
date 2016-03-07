import DS from 'ember-data';

export default DS.Model.extend({
  period: DS.attr('string'),
  minute: DS.attr('number'),
  second: DS.attr('number'),
  scoredBy: DS.belongsTo('hockey/skater/result'),
  assistedBy: DS.belongsTo('hockey/skater/result'),
  alsoAssistedBy: DS.belongsTo('hockey/skater/result')
});

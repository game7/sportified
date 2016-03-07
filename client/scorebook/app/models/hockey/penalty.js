import DS from 'ember-data';

export default DS.Model.extend({
  period: DS.attr('string'),
  minute: DS.attr('number'),
  second: DS.attr('number'),
  committedBy: DS.belongsTo('hockey/skater/result'),
  infraction: DS.attr('string'),
  duration: DS.attr('number'),
  severity: DS.attr('string')
});

import DS from 'ember-data';

export default DS.Model.extend({
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),
  jerseyNumber: DS.attr('string'),
  statsheet: DS.belongsTo('statsheet'),
  team: DS.belongsTo('team')
});

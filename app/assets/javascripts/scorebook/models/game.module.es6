import DS from 'ember-data';

export default DS.Model.extend({
  startsOn: DS.attr('date'),
  endsOn: DS.attr('date'),
  summary: DS.attr('string')
});

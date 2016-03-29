// for more details see: http://emberjs.com/guides/models/defining-models/

Sportified.Facility = DS.Model.extend({
  type: DS.attr('string'),
  name: DS.attr('string'),
  location: DS.belongsTo('location')
});

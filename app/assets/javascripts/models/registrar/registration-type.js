// for more details see: http://emberjs.com/guides/models/defining-models/

Sportified.RegistrarRegistrationType = DS.Model.extend({
  session: DS.belongsTo('session'),
  title: DS.attr('string{30}'),
  description: DS.attr('string'),
  price: DS.attr('number'),
  quantityAllowed: DS.attr('number'),
  quantityAvailable: DS.attr('number')
});

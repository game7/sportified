// for more details see: http://emberjs.com/guides/models/defining-models/

Sportified.RegistrarSession = DS.Model.extend({
  registrable: DS.attr('references{polymorphic}'),
  title: DS.attr('string{30}'),
  description: DS.attr('string'),
  registrationsAllowed: DS.attr('number'),
  registrationsAvailable: DS.attr('number')
});

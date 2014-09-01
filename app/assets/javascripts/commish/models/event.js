App.Event = DS.Model.extend({
  startsOn: DS.attr('date'),
  start: Em.computed.alias('startsOn'),
  endsOn: DS.attr('date'),
  end: Em.computed.alias('endsOn'),
  allDay: DS.attr('boolean'),
  duration: DS.attr('number'),
  summary: DS.attr('string'),
  name: Em.computed.alias('summary'),
  description: DS.attr('string')
});
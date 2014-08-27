App.Event = DS.Model.extend({
  startsOn: DS.attr('date'),
  endsOn: DS.attr('date'),
  allDay: DS.attr('boolean'),
  duration: DS.attr('number'),
  summary: DS.attr('string'),
  description: DS.attr('string')
});
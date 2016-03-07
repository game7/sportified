import DS from 'ember-data';
import { memberAction, collectionAction } from 'ember-api-actions';

export default DS.Model.extend({

  startsOn: DS.attr('date'),
  endsOn: DS.attr('date'),
  summary: DS.attr('string'),
  statsheet: DS.belongsTo('statsheet'),
  homeTeam: DS.belongsTo('team'),
  awayTeam: DS.belongsTo('team'),

  statify: memberAction( { path: 'statify' })

});

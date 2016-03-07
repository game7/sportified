import Statsheet from '../statsheet';
import DS from 'ember-data';

export default Statsheet.extend({
  skaters: DS.hasMany('hockey/skater/result'),
  goaltenders: DS.hasMany('hockey/goaltender/result'),
  goals: DS.hasMany('hockey/goal'),
  penalties: DS.hasMany('hockey/penalty')
});

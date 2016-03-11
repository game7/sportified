import Ember from 'ember';
import moment from 'moment';

export default Ember.Controller.extend({
  gameController: Ember.inject.controller("game"),
  game: Ember.computed.reads('gameController.game'),
});

import Ember from 'ember';

export default Ember.Component.extend({
	tagName: 'li',
  classNames: ['day-column-event'],
  // attributeBindings: ['style'],
  
  // style: function() {
  //   return `height: ${this.get('height')}px; top: ${this.get('top')}px; position: absolute;`;
  // }.property('height', 'top'),  
  
  init: function() {
    this._super();
    let event = this.get('event');

    let eventStart = moment(event.starts_on),
        eventStartMinutes = (eventStart.hour() * 60) + eventStart.minutes(),
        dayStartMinutes = this.get('day-start-hour') * 60;

    this.set('top', eventStartMinutes - dayStartMinutes);
    this.set('height', event.duration);

  }
})
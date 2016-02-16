//= require ember
//= require ember-data
//= require ember-rails/application
//= require moment
//= require ./environment
//= require ./calendar
//= require_self

import Calendar from 'calendar/calendar';
import Router from 'calendar/router';
import loadInitializers from 'ember/load-initializers';
import config from 'calendar/environment'; // You can use `config` for application specific variables such as API key, etc.

loadInitializers(Calendar, 'calendar');

Calendar.create({
	Router: Router
	// LOG_TRANSITIONS_INTERNAL:  true,
	// LOG_ACTIVE_GENERATION:     true,
	// LOG_VIEW_LOOKUPS:          true,
	// LOG_RESOLVER:              true
});

// TODO - remove this when we switch to ajax data loading
sportified.events.forEach(function(event) {
	event.starts_on = moment(event.starts_on).add(7, 'h').toISOString();
	event.ends_on = moment(event.ends_on).add(7, 'h').toISOString();
});
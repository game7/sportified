//= require ember
//= require ember-data
//= require ember-rails/application
//= require moment
//= require ./environment
//= require ./scorebook
//= require_self

import Scorebook from 'scorebook/scorebook';
import Router from 'scorebook/router';
import loadInitializers from 'ember/load-initializers';
import config from 'scorebook/environment'; // You can use `config` for application specific variables such as API key, etc.

loadInitializers(Scorebook, 'scorebook');

Scorebook.create({
	Router: Router
	// LOG_TRANSITIONS_INTERNAL:  true,
	// LOG_ACTIVE_GENERATION:     true,
	// LOG_VIEW_LOOKUPS:          true,
	// LOG_RESOLVER:              true
});

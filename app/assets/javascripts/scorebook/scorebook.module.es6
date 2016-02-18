//= require_tree ./adapters
//= require_tree ./mixins
//= require_tree ./models
//= require_tree ./controllers
//= require_tree ./views
//= require_tree ./helpers
//= require_tree ./components
//= require_tree ./templates
//= require_tree ./routes
//= require ./router
//
//= require_self

import Ember from 'ember';
import Resolver from 'ember/resolver';
import Application from 'ember-rails/application';

const name = 'scorebook';

const App = Application.extend({
	modulePrefix: name,
	rootElement: `#${name}-app`,
	Resolver: Resolver.extend({
		resolveTemplate: function(parsedName) {
			parsedName.fullNameWithoutType = name + '/' + parsedName.fullNameWithoutType;
			return this._super(parsedName);
		}
	})
});

export default App;

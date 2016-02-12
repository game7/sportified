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

// for more details see: http://emberjs.com/guides/application/
const App = Application.extend({
	modulePrefix: 'calendar',
	rootElement: '#calendar-app',
	Resolver: Resolver.extend({
		resolveTemplate: function(parsedName) {
			parsedName.fullNameWithoutType = "calendar/" + parsedName.fullNameWithoutType;
			return this._super(parsedName);
		}
	})
});

export default App;

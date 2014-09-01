//= require handlebars
//= require ember
//= require ember-data
//= require ember-calendar
//= require moment
//= require_self
//= require ./commish/include

// for more details see: http://emberjs.com/guides/application/
App = Ember.Application.create({
    rootElement: '#main',
    Resolver: Ember.DefaultResolver.extend({
      resolveTemplate: function(parsedName) {
        if (parsedName.fullNameWithoutType.indexOf('ember-') == -1) {
          parsedName.fullNameWithoutType = "commish/" + parsedName.fullNameWithoutType;
        }
        return this._super(parsedName);
      }
    }),
    LOG_TRANSITIONS: true,
    LOG_BINDINGS: true,
    LOG_VIEW_LOOKUPS: true,
    LOG_STACKTRACE_ON_DEPRECATION: true,
    LOG_VERSION: true,
    debugMode: true
});
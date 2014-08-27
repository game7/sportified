// Override the default adapter with the `DS.ActiveModelAdapter` which
// is built to work nicely with the ActiveModel::Serializers gem.
App.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  namespace: 'admin'
});

App.ApplicationSerializer = DS.ActiveModelSerializer.extend({
    normalize: function(type, hash, prop) {
      if (hash['id']) {
        hash['id'] = hash['id']['$oid'];
      }
      return this._super.apply(this, arguments)
    }
});

App.ApplicationStore = DS.Store.extend();

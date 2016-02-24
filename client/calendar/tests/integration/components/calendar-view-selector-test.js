import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('calendar-view-selector', 'Integration | Component | calendar view selector', {
  integration: true
});

test('it renders', function(assert) {
  
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +

  this.render(hbs`{{calendar-view-selector}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:" + EOL +
  this.render(hbs`
    {{#calendar-view-selector}}
      template block text
    {{/calendar-view-selector}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

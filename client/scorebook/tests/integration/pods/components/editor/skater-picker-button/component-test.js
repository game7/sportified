import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('editor/skater-picker-button', 'Integration | Component | editor/skater picker button', {
  integration: true
});

test('it renders', function(assert) {
  
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +

  this.render(hbs`{{editor/skater-picker-button}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:" + EOL +
  this.render(hbs`
    {{#editor/skater-picker-button}}
      template block text
    {{/editor/skater-picker-button}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

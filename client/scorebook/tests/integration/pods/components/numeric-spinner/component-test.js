import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('numeric-spinner', 'Integration | Component | numeric spinner', {
  integration: true
});

test('it renders', function(assert) {
  
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +

  this.render(hbs`{{numeric-spinner}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:" + EOL +
  this.render(hbs`
    {{#numeric-spinner}}
      template block text
    {{/numeric-spinner}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

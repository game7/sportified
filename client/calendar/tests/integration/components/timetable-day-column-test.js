import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('timetable-day-column', 'Integration | Component | timetable day column', {
  integration: true
});

test('it renders', function(assert) {
  
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +

  this.render(hbs`{{timetable-day-column}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:" + EOL +
  this.render(hbs`
    {{#timetable-day-column}}
      template block text
    {{/timetable-day-column}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

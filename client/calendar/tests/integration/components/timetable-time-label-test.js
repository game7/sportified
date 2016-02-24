import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('timetable-time-label', 'Integration | Component | timetable time label', {
  integration: true
});

test('it renders', function(assert) {
  
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +

  this.render(hbs`{{timetable-time-label}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:" + EOL +
  this.render(hbs`
    {{#timetable-time-label}}
      template block text
    {{/timetable-time-label}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});

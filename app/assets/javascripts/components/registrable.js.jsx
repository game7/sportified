var Registrable = React.createClass({

  getInitialState: function() {
    return this.props.registrable;
  },

  setValue: function(property, event) {
    var object= {};
    object[property] = event.target.value;
    this.setState(object);
  },

  handleSubmit: function(e) {
    e.preventDefault();
    console.log(this.state);
  },

  render: function() {
    return (
      <div>
        <h1>Registrables!!</h1>
        <Form onSubmit={this.handleSubmit}>
          <Panel>
            <Panel.Heading title="Basic Info"/>
            <Panel.Body>
              <Form.Input model={this.state} property="title" onChange={this.setValue.bind(this, 'title')} />
              <Form.Textarea model={this.state} property="description" onChange={this.setValue.bind(this, 'description')} />
            </Panel.Body>
          </Panel>
          <Form.Submit label="Update Registrable" />
        </Form>
      </div>
    );
  }
});

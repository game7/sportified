var Form = React.createClass({

  propTypes: {
    onSubmit: React.PropTypes.func.isRequired
  },

  render: function() {
    return (
      <form onSubmit={this.props.onSubmit}>
        { this.props.children }
      </form>
    );
  }
});

Form.Group = React.createClass({
  render: function() {
    return (
      <div className="form-group">
        { this.props.children }
      </div>
    );
  }
});

Form.Input = React.createClass({

  propTypes: {
    model: React.PropTypes.object.isRequired,
    property: React.PropTypes.string.isRequired,
    onChange: React.PropTypes.func.isRequired
  },

  value: function() {
    return this.props.model[this.props.property];
  },

  render: function() {
    return (
      <Form.Group>
        <label className="control-label" htmlFor={this.props.property}>{this.props.property}</label>
        <input
          type="text"
          id={this.props.property}
          className="form-control"
          value={this.value()}
          onChange={this.props.onChange}
        />
      </Form.Group>
    );
  }
});

Form.Textarea = React.createClass({

  propTypes: {
    model: React.PropTypes.object.isRequired,
    property: React.PropTypes.string.isRequired,
    onChange: React.PropTypes.func.isRequired
  },

  value: function() {
    return this.props.model[this.props.property];
  },

  render: function() {
    return (
      <Form.Group>
        <label className="control-label" htmlFor={this.props.property}>{this.props.property}</label>
        <textarea
          type="text"
          id={this.props.property}
          className="form-control"
          value={this.value()}
          onChange={this.props.onChange}
        />
      </Form.Group>
    );
  }
});

Form.Submit = React.createClass({

  propTypes: {
    label: React.PropTypes.string.isRequired
  },

  render: function() {
    return (
      <input type="submit" value={this.props.label} className="btn btn-primary"/>
    );
  }
});

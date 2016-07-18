var Panel = React.createClass({
  render: function() {
    return (
      <div className="panel panel-default">
        { this.props.children }
      </div>
    );
  }
});

Panel.Heading = React.createClass({
  render: function() {
    return (
      <div className="panel-heading">
        <h3 className="panel-title">{this.props.title}</h3>
      </div>
    );
  }
})

Panel.Body = React.createClass({
  render: function() {
    return (
      <div className="panel-body">
        { this.props.children }
      </div>
    );
  }
})

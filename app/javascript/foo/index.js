"use strict";
var React = require("react");
var ReactDOM = require("react-dom");
var Hello = function (props) { return (React.createElement("div", { className: "alert alert-success" }, "Hello Chris")); };
document.addEventListener('DOMContentLoaded', function () {
    ReactDOM.render(React.createElement(Hello, null), document.getElementById('page-header').appendChild(document.createElement('div')));
});

"use strict";
var React = require("react");
var ReactDOM = require("react-dom");
var calendar_1 = require("./calendar");
document.addEventListener('DOMContentLoaded', function () {
    ReactDOM.render(React.createElement(calendar_1.default, null), document.getElementById('page-header').appendChild(document.createElement('div')));
});

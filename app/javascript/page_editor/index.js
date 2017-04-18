"use strict";
var React = require("react");
var ReactDOM = require("react-dom");
require("whatwg-fetch");
var edit_1 = require("./edit");
document.addEventListener('DOMContentLoaded', function () {
    ReactDOM.render(React.createElement(edit_1.Edit, null), document.getElementById('main').appendChild(document.createElement('div')));
});

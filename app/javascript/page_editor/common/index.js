"use strict";
var React = require("react");
exports.Spacer = function () { return (React.createElement("span", null, " ")); };
exports.Row = function (props) { return (React.createElement("div", { className: "row" }, props.children)); };
var BREAKS = ['xs', 'sm', 'md', 'lg'];
exports.Col = function (props) {
    var classes = BREAKS.map(function (b) { return props[b] ? "col-" + b + "-" + props[b] : ''; });
    return (React.createElement("div", { className: classes.join(' ') }, props.children));
};

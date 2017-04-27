"use strict";
var __assign = (this && this.__assign) || Object.assign || function(t) {
    for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
    }
    return t;
};
var React = require("react");
var icons_1 = require("./icons");
exports.ButtonGroup = function (props) { return (React.createElement("div", { className: "btn-group", role: "group" }, props.children)); };
exports.Button = function (props) {
    var className = "btn " + props.className + " " + (props.active ? 'active' : '');
    var onClick = props.onClick;
    if (props.icon)
        return (React.createElement("button", { type: "button", className: className, onClick: onClick, disabled: props.disabled },
            React.createElement(icons_1.Icon, { name: props.icon, label: props.label })));
    else
        return (React.createElement("button", { type: "button", className: className, onClick: onClick, disabled: props.disabled }, props.label));
};
exports.DefaultButton = function (props) {
    return (React.createElement(exports.Button, __assign({}, props, { className: "btn-default" })));
};
exports.PrimaryButton = function (props) {
    return (React.createElement(exports.Button, __assign({}, props, { className: "btn-primary" })));
};

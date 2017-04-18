"use strict";
var React = require("react");
var index_1 = require("./index");
exports.Icon = function (props) {
    if (!props.label)
        return (React.createElement("i", { className: "fa fa-" + props.name }));
    else
        return (React.createElement("span", null,
            React.createElement("i", { className: "fa fa-" + props.name }),
            React.createElement(index_1.Spacer, null),
            props.label));
};

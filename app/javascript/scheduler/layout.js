"use strict";
var React = require("react");
exports.Row = function (props) { return (React.createElement("div", { className: "row" }, props.children)); };
exports.Col = function (props) {
    var classes = [];
    "xs|sm|md|lg".split("|").forEach(function (brk) {
        if (props[brk]) {
            classes.push("col-" + brk + "-" + props[brk]);
        }
    });
    return (React.createElement("div", { className: classes.join(" ") }, props.children));
};

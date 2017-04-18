"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var React = require("react");
var PageTitle = (function (_super) {
    __extends(PageTitle, _super);
    function PageTitle() {
        var _this = _super.call(this) || this;
        _this.previous = '';
        _this.emitChange = _this.emitChange.bind(_this);
        return _this;
    }
    PageTitle.prototype.emitChange = function () {
        var title = this['getDOMNode']().innerText;
        if (this.props.onChange && title !== this.previous) {
            this.props.onChange(title);
        }
        this.previous = title;
    };
    PageTitle.prototype.render = function () {
        return (React.createElement("h1", { contentEditable: true, onInput: this.emitChange, onBlur: this.emitChange }, this.props.title));
    };
    return PageTitle;
}(React.Component));
exports.PageTitle = PageTitle;

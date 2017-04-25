"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var React = require("react");
var ReactDOM = require("react-dom");
var PageTitle = (function (_super) {
    __extends(PageTitle, _super);
    function PageTitle() {
        var _this = _super.call(this) || this;
        _this.lastHtml = '';
        _this.emitChange = _this.emitChange.bind(_this);
        return _this;
    }
    PageTitle.prototype.componentWillUpdate = function (nextProps) {
        var element = ReactDOM.findDOMNode(this);
        if (nextProps.title !== element.innerHTML) {
            element.innerHTML = nextProps.title;
        }
    };
    PageTitle.prototype.shouldComponentUpdate = function (nextProps) {
        if (nextProps.title !== ReactDOM.findDOMNode(this).innerHTML) {
            return true;
        }
        return false;
    };
    PageTitle.prototype.emitChange = function () {
        var element = ReactDOM.findDOMNode(this);
        var title = element.innerHTML;
        if (this.props.onChange && title !== this.lastHtml) {
            this.props.onChange(title);
        }
        this.lastHtml = title;
    };
    PageTitle.prototype.render = function () {
        var _this = this;
        return (React.createElement("h1", { ref: function (element) { _this.element = element; }, contentEditable: true, style: { display: 'inline-block' }, onInput: this.emitChange, onBlur: this.emitChange, dangerouslySetInnerHTML: { __html: this.props.title } }));
    };
    return PageTitle;
}(React.Component));
exports.PageTitle = PageTitle;

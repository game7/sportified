"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var __assign = (this && this.__assign) || Object.assign || function(t) {
    for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
    }
    return t;
};
var React = require("react");
var common_1 = require("./common");
var buttons_1 = require("./common/buttons");
var page_title_1 = require("./editor/page-title");
var editor_1 = require("./editor/editor");
var Edit = (function (_super) {
    __extends(Edit, _super);
    function Edit() {
        var _this = _super.call(this) || this;
        [
            'handleViewChange',
            'handleTitleChange',
            'handleContentChange',
            'handleSave'
        ].forEach(function (fn) { _this[fn] = _this[fn].bind(_this); });
        return _this;
    }
    Edit.prototype.componentWillMount = function () {
        var page = Window['sportified'].page;
        var id = page.id, title = page.title, content = page.content;
        this.setState({
            id: id,
            title: title,
            content: content,
            viewName: 'MARKDOWN',
            loading: false
        });
    };
    Edit.prototype.handleContentChange = function (content) {
        this.setState({ content: content, dirty: true });
    };
    Edit.prototype.handleTitleChange = function (title) {
        this.setState({ title: title, dirty: true });
    };
    Edit.prototype.handleSave = function () {
        var _this = this;
        var _a = this.state, dirty = _a.dirty, id = _a.id, title = _a.title, content = _a.content;
        var token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
        if (dirty) {
            fetch("/pages/" + id, {
                method: "PATCH",
                credentials: 'same-origin',
                body: JSON.stringify({ page: { title: title, content: content } }),
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-Token": token
                },
            }).then(function () { return _this.setState(function (prev, props) {
                return __assign({}, prev, { saving: false, dirty: false });
            }); });
        }
    };
    Edit.prototype.handleViewChange = function (viewName) {
        var _this = this;
        var content = this.state.content;
        if (viewName == 'HTML') {
            if (content == '') {
                this.setState({
                    viewName: viewName,
                    html: ''
                });
            }
            else {
                fetch('/markdown', {
                    method: "POST",
                    body: JSON.stringify({ markdown: content }),
                    headers: {
                        "Content-Type": "application/json"
                    },
                }).then(function (response) { return response.json(); })
                    .then(function (json) { return _this.setState({
                    viewName: viewName,
                    html: json.html,
                    toc: json.toc
                }); });
            }
        }
        else {
            this.setState({ viewName: viewName });
        }
    };
    Edit.prototype.render = function () {
        var _this = this;
        var _a = this.state, title = _a.title, content = _a.content, html = _a.html, toc = _a.toc, viewName = _a.viewName;
        return (React.createElement("div", null,
            React.createElement("div", { className: "page-title clearfix" },
                React.createElement(page_title_1.PageTitle, { title: title, onChange: this.handleTitleChange }),
                React.createElement("div", { className: "pull-right" },
                    React.createElement(buttons_1.ButtonGroup, null,
                        React.createElement(buttons_1.DefaultButton, { icon: "edit", label: "Edit", active: this.state.viewName == 'MARKDOWN', onClick: function () { return _this.handleViewChange('MARKDOWN'); } }),
                        React.createElement(buttons_1.DefaultButton, { icon: "eye", label: "Preview", active: this.state.viewName == 'HTML', onClick: function () { return _this.handleViewChange('HTML'); } })),
                    React.createElement(common_1.Spacer, null),
                    React.createElement(buttons_1.PrimaryButton, { icon: "save", label: "Save", onClick: this.handleSave, disabled: !this.state.dirty }))),
            React.createElement("div", { style: { display: viewName == 'MARKDOWN' ? 'block' : 'none' } },
                React.createElement(editor_1.Editor, { onChange: this.handleContentChange, value: content })),
            React.createElement("div", { style: { display: viewName == 'HTML' ? 'block' : 'none' } },
                React.createElement("div", { className: "toc", dangerouslySetInnerHTML: { __html: toc } }),
                React.createElement("div", { dangerouslySetInnerHTML: { __html: html } }))));
    };
    return Edit;
}(React.Component));
exports.Edit = Edit;

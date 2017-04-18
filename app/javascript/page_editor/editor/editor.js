"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var React = require("react");
var react_ace_1 = require("react-ace");
require("brace/mode/markdown");
require("brace/theme/chrome");
var toolbar_1 = require("./toolbar");
var Editor = (function (_super) {
    __extends(Editor, _super);
    function Editor() {
        var _this = _super.call(this) || this;
        _this.handleLoad = _this.handleLoad.bind(_this);
        _this.insertSnippet = _this.insertSnippet.bind(_this);
        return _this;
    }
    Editor.prototype.handleLoad = function (editor) {
        editor.setShowInvisibles(true);
        this.setState({ editor: editor });
    };
    Editor.prototype.insertSnippet = function (snippet) {
        var editor = this.state.editor;
        var selection = editor.getSelectedText();
        if (selection == '' && snippet.content) {
            selection = snippet.content;
        }
        var newline = snippet.newline && editor.selection.getRange().start != 0 ? '\n\n' : '';
        var tag = [newline, snippet.before, selection, snippet.after].join('');
        editor.session.replace(editor.selection.getRange(), tag);
        editor.focus();
    };
    Editor.prototype.render = function () {
        var _a = this.props, value = _a.value, onChange = _a.onChange;
        return (React.createElement("div", null,
            React.createElement(toolbar_1.Toolbar, { onAction: this.insertSnippet }),
            React.createElement("div", { style: { border: "1px solid #ccc ", borderRadius: 4 } },
                React.createElement(react_ace_1.default, { mode: "markdown", theme: "chrome", showGutter: false, showPrintMargin: false, wrapEnabled: true, width: "100%", onChange: onChange, name: "md-editor", value: value, onLoad: this.handleLoad }))));
    };
    return Editor;
}(React.Component));
exports.Editor = Editor;

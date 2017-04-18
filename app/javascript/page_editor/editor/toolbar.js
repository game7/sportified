"use strict";
var React = require("react");
var common_1 = require("../common");
var buttons_1 = require("../common/buttons");
var h1 = {
    before: '# ',
    newline: true
};
var h2 = {
    before: '## ',
    newline: true
};
var h3 = {
    before: '### ',
    newline: true
};
var bold = {
    before: '**',
    content: 'text',
    after: '**'
};
var italic = {
    before: '*',
    content: 'text',
    after: '*'
};
var underline = {
    before: '_',
    content: 'text',
    after: '_'
};
var strikethrough = {
    before: '~~',
    content: 'text',
    after: '~~'
};
var ul = {
    before: '* ',
    newline: true
};
var ol = {
    before: '1. ',
    newline: true
};
var table = {
    before: [
        '|   |   |   |',
        '|---|---|---|',
        '|   |   |   |',
        '|   |   |   |',
    ].join('\n'),
    newline: true
};
var link = {
    before: '[',
    content: 'link title',
    after: '](http://)'
};
var image = {
    before: '![',
    content: 'image title',
    after: '](http://)'
};
exports.Toolbar = function (props) {
    function action(snippet) {
        return function () { return props.onAction(snippet); };
    }
    return (React.createElement("div", { style: { marginBottom: 5 }, className: "clearfix" },
        React.createElement("div", null,
            React.createElement(buttons_1.ButtonGroup, null,
                React.createElement(buttons_1.DefaultButton, { label: "H1", onClick: action(h1) }),
                React.createElement(buttons_1.DefaultButton, { label: "H2", onClick: action(h2) }),
                React.createElement(buttons_1.DefaultButton, { label: "H3", onClick: action(h3) })),
            React.createElement(common_1.Spacer, null),
            React.createElement(buttons_1.ButtonGroup, null,
                React.createElement(buttons_1.DefaultButton, { icon: "bold", onClick: action(bold) }),
                React.createElement(buttons_1.DefaultButton, { icon: "italic", onClick: action(italic) }),
                React.createElement(buttons_1.DefaultButton, { icon: "underline", onClick: action(underline) }),
                React.createElement(buttons_1.DefaultButton, { icon: "strikethrough", onClick: action(strikethrough) })),
            React.createElement(common_1.Spacer, null),
            React.createElement(buttons_1.ButtonGroup, null,
                React.createElement(buttons_1.DefaultButton, { icon: "list-ul", onClick: action(ul) }),
                React.createElement(buttons_1.DefaultButton, { icon: "list-ol", onClick: action(ol) }),
                React.createElement(buttons_1.DefaultButton, { icon: "table", onClick: action(table) })),
            React.createElement(common_1.Spacer, null),
            React.createElement(buttons_1.ButtonGroup, null,
                React.createElement(buttons_1.DefaultButton, { icon: "link", onClick: action(link) }),
                React.createElement(buttons_1.DefaultButton, { icon: "image", onClick: action(image) })),
            React.createElement(common_1.Spacer, null),
            React.createElement(buttons_1.DefaultButton, { icon: "upload", onClick: action(image) }))));
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = exports.Toolbar;

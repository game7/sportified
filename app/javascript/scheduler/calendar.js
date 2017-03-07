"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var React = require("react");
var BigCalendar = require("react-big-calendar");
var moment = require("moment");
require("react-big-calendar/lib/css/react-big-calendar.css");
var store_1 = require("./store");
var layout_1 = require("./layout");
BigCalendar.momentLocalizer(moment);
var Calendar = (function (_super) {
    __extends(Calendar, _super);
    function Calendar() {
        var _this = _super.call(this) || this;
        _this.state = {
            events: []
        };
        _this.onNavigate = _this.onNavigate.bind(_this);
        return _this;
    }
    Calendar.prototype.componentDidMount = function () {
        this.fetchEvents(new Date());
    };
    Calendar.prototype.onNavigate = function (date, view) {
        this.fetchEvents(date);
    };
    Calendar.prototype.fetchEvents = function (date) {
        var _this = this;
        store_1.Store.getEvents(date).then(function (events) {
            _this.setState({
                events: events
            });
        });
    };
    Calendar.prototype.render = function () {
        var events = this.state.events;
        return (React.createElement(layout_1.Row, null,
            React.createElement(layout_1.Col, { sm: 2 }),
            React.createElement(layout_1.Col, { sm: 10 },
                React.createElement("div", { style: { height: 800, marginTop: 20 } },
                    React.createElement(BigCalendar, { events: events, startAccessor: 'startsOn', endAccessor: 'endsOn', titleAccessor: 'summary', onNavigate: this.onNavigate })))));
    };
    return Calendar;
}(React.Component));
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = Calendar;

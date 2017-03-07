"use strict";
var __assign = (this && this.__assign) || Object.assign || function(t) {
    for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
    }
    return t;
};
var moment = require("moment");
var Store = (function () {
    function Store() {
    }
    Store.getEvents = function (date) {
        var from = moment(date).format("YYYY-MM-01");
        var to = moment(date).format("YYYY-MM-") + moment(date).daysInMonth();
        return fetch("/api/events?from=" + from + "&to=" + to)
            .then(function (response) { return response.json(); })
            .then(function (json) { return json['events']; })
            .then(function (data) { return data.map(function (event) {
            return __assign({}, event, { startsOn: new Date(event.startsOn), endsOn: new Date(event.endsOn) });
        }); });
    };
    return Store;
}());
exports.Store = Store;
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = Store;

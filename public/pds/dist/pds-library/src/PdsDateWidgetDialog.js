"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var PdsWidget_1 = require('./PdsWidget');
var PdsDateWidgetDialog = (function (_super) {
    __extends(PdsDateWidgetDialog, _super);
    function PdsDateWidgetDialog() {
        _super.apply(this, arguments);
        this.is = 'pds-date-picker-dialog';
        this.holdRefresh = false;
        this.properties = {
            month: {
                type: String,
                observer: 'monthChange'
            },
            year: {
                type: String,
                observer: 'yearChange'
            },
            possibleYears: {
                type: Array
            },
            dataMaxdate: {
                type: String
            },
            dataMindate: {
                type: String
            }
        };
    }
    PdsDateWidgetDialog.prototype.setMonthLabels = function () {
        var monthLabels = [];
        this.pds.i18n.locale.DATETIME_FORMATS.SHORTMONTH.forEach(function (month, index) {
            var textValueObj = {
                value: String(index),
                text: month
            };
            monthLabels.push(textValueObj);
        });
        this.monthLabels = monthLabels;
    };
    PdsDateWidgetDialog.prototype.ready = function () {
        _super.prototype.ready.call(this);
        this.setMonthLabels();
        this.dayLabels = this.pds.i18n.locale.DATETIME_FORMATS.SHORTDAY;
        var today = new Date();
        today.setHours(0);
        today.setMinutes(0);
        today.setSeconds(0);
        today.setMilliseconds(0);
        this.todayTimeStamp = today.getTime();
        if (this.dataMaxdate != null) {
            this.maxDateTimeStamp = (new Date(this.dataMaxdate)).getTime();
        }
        if (this.dataMindate != null) {
            this.minDateTimeStamp = (new Date(this.dataMindate)).getTime();
        }
        var d;
        if (this.value != null) {
            d = this.value;
        }
        else {
            d = today;
        }
        this.holdRefresh = true;
        this.month = String(d.getMonth());
        this.holdRefresh = false;
        this.year = String(d.getFullYear());
    };
    PdsDateWidgetDialog.prototype.getSelectedMonth = function (index) {
        return String(index) === this.month;
    };
    PdsDateWidgetDialog.prototype.getSelectedYear = function (yearValue) {
        return String(yearValue) === String(this.year);
    };
    PdsDateWidgetDialog.prototype.getSelectedDateClass = function (dateTimeStamp, value) {
        if (value != null && value.getTime() === dateTimeStamp) {
            return 'pds-selected-day';
        }
    };
    PdsDateWidgetDialog.prototype.getTodayClass = function (dateTimeStamp) {
        if (dateTimeStamp != null && dateTimeStamp === this.todayTimeStamp) {
            return 'pds-date-picker-today';
        }
    };
    PdsDateWidgetDialog.prototype.getIsWeekendClass = function (isWeekend) {
        if (isWeekend === true) {
            return 'pds-weekend-day';
        }
    };
    PdsDateWidgetDialog.prototype.getInvisibleClass = function (dayNum) {
        if (dayNum == null) {
            return 'pds-invisible';
        }
    };
    PdsDateWidgetDialog.prototype.getDisabledItemClass = function (dateTimeStamp) {
        if (this.isTimeStampDisabled(dateTimeStamp)) {
            return 'pds-disabled-day';
        }
    };
    PdsDateWidgetDialog.prototype.isTimeStampDisabled = function (dateTimeStamp) {
        if (dateTimeStamp != null) {
            if (this.maxDateTimeStamp != null && this.maxDateTimeStamp < dateTimeStamp) {
                return true;
            }
            if (this.minDateTimeStamp != null && this.minDateTimeStamp > dateTimeStamp) {
                return true;
            }
        }
        return false;
    };
    PdsDateWidgetDialog.prototype.selectDate = function (event) {
        var dateTimeAttr = event.target.getAttribute('data-date-time');
        var dateTimeStamp = new Date(parseInt(dateTimeAttr));
        if (this.isTimeStampDisabled(dateTimeStamp)) {
            return;
        }
        this.value = dateTimeStamp;
        var e = new Event('pds-date-change-event');
        this.dispatchEvent(e);
    };
    PdsDateWidgetDialog.prototype.monthChange = function () {
        if (this.month != null && this.holdRefresh !== true) {
            this.updateDays();
        }
    };
    PdsDateWidgetDialog.prototype.yearChange = function () {
        this.updateAvailableYears(this.year);
        this.updateDays();
    };
    PdsDateWidgetDialog.prototype.updateAvailableYears = function (year) {
        var newYears = [];
        for (var i = 0; i < 21; i++) {
            var val = String(year - 10 + i);
            newYears.push({ value: val, text: val });
        }
        this.possibleYears = newYears;
    };
    PdsDateWidgetDialog.prototype.previousMonth = function () {
        if (this.month === '0') {
            this.holdRefresh = true;
            this.month = '11';
            this.holdRefresh = false;
            this.year = String(parseInt(this.year) - 1);
        }
        else {
            this.month = String(parseInt(this.month) - 1);
        }
    };
    PdsDateWidgetDialog.prototype.nextMonth = function () {
        if (this.month === '11') {
            this.holdRefresh = true;
            this.month = '0';
            this.holdRefresh = false;
            this.yearIncrement = true;
            this.year = String(parseInt(this.year) + 1);
            this.yearIncrement = false;
        }
        else {
            this.month = String(parseInt(this.month) + 1);
        }
    };
    PdsDateWidgetDialog.prototype.setDate = function (dateTimeString) {
        this.value = new Date(dateTimeString);
        this.updateDays();
    };
    PdsDateWidgetDialog.prototype.updateDays = function () {
        this.days = this.pds.utils.generateDays(parseInt(this.year), parseInt(this.month));
    };
    PdsDateWidgetDialog.prototype.messageKeysUpdated = function () {
        this.dayLabels = this.pds.i18n.locale.DATETIME_FORMATS.SHORTDAY;
        this.setMonthLabels();
    };
    return PdsDateWidgetDialog;
}(PdsWidget_1.PdsWidget));
exports.PdsDateWidgetDialog = PdsDateWidgetDialog;

//# sourceMappingURL=PdsDateWidgetDialog.js.map

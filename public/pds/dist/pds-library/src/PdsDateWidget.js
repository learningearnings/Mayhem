"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var PdsAbstractInputWidget_1 = require('./PdsAbstractInputWidget');
var PdsDateWidget = (function (_super) {
    __extends(PdsDateWidget, _super);
    function PdsDateWidget() {
        _super.apply(this, arguments);
        this.is = 'pds-date-widget';
        this.properties = {
            name: String,
            dataLabelText: String,
            dataBadgeText: String,
            dataHelperText: String,
            dataRegexErrorText: String,
            dataFieldHelpText: String,
            dataPlaceholderText: String,
            dataTooltipText: String,
            dataIsrequired: {
                type: Boolean,
                value: false,
                observer: 'setRequired',
                notify: true
            },
            dataIsreadonly: {
                type: Boolean,
                value: false,
                observer: 'setReadonly',
                notify: true
            },
            hasHadError: {
                value: false,
                observer: 'setShowErrorMessage'
            },
            dataMaxdate: String,
            dataMindate: String,
            dataMaxdate_exclusive: String,
            dataMindate_exclusive: String
        };
        this.showDatePickerDialog = false;
    }
    PdsDateWidget.prototype.ready = function () {
        this.messageKeysUpdated();
    };
    PdsDateWidget.prototype.messageKeysUpdated = function () {
        this.buttonText = this.pds.i18n.getText(this.pds.i18n.widgetKeys['dateWidget.open_picker_dialog']);
    };
    PdsDateWidget.prototype.dateChanged = function (e) {
        this.value = this.pds.i18n.localizeDate(e.target.value);
        this.inputChange();
        this.closeDatePickerDialog();
    };
    ;
    PdsDateWidget.prototype.setValue = function (value, skip) {
        if (skip === void 0) { skip = false; }
        if (value == null) {
            value = '';
        }
        var inputEl = this.querySelector('input');
        if (inputEl != null && value !== inputEl.value) {
            inputEl.value = value;
        }
        if (skip !== true) {
            this.setModelValue(this.pds.i18n.deLocalizeDate(value), true);
        }
    };
    ;
    PdsDateWidget.prototype.setModelValue = function (modelValue, skip) {
        if (skip === void 0) { skip = false; }
        var ele = this.querySelector('input');
        if (ele != null && modelValue !== ele.modelValue) {
            ele.modelValue = modelValue;
            this.dialogValue = modelValue;
            if (skip !== true) {
                this.setValue(this.pds.i18n.localizeDate(modelValue), true);
            }
            return true;
        }
        return false;
    };
    ;
    PdsDateWidget.prototype.openDatePickerDialog = function () {
        this.showDatePickerDialog = true;
    };
    ;
    PdsDateWidget.prototype.closeDatePickerDialog = function () {
        this.showDatePickerDialog = false;
    };
    ;
    PdsDateWidget.prototype.isValidDate = function () {
        return this.pds.i18n.isValidDate(this.value);
    };
    ;
    PdsDateWidget.prototype.validateWidget = function () {
        if (this.value == null || this.value === '') {
        }
        var inputIsValid = this.isValidDate();
        var passedMin = true;
        var passedMax = true;
        if (inputIsValid) {
            this.setValue(this.value);
            if (this.dataMindate != null) {
                var minDateObj = new Date(this.dataMindate);
                var exclusiveMin = this.dataMindate_exclusive;
                passedMin = this.validateValueAfterMin(this.pds.utils.dateToTime(this.modelValue), this.pds.utils.dateToTime(minDateObj), exclusiveMin);
                if (!passedMin) {
                    var errorMsg = void 0;
                    if (exclusiveMin == null) {
                        errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['dateWidget.failedMinDate'], this.pds.i18n.localizeDate(minDateObj));
                    }
                    else {
                        errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['dateWidget.failedMinDateExclusive'], this.pds.i18n.localizeDate(minDateObj));
                    }
                    this.setError(errorMsg);
                    inputIsValid = false;
                }
            }
            if (this.dataMaxdate != null) {
                var maxDateObj = new Date(this.dataMaxdate);
                var exclusiveMax = this.dataMaxdate_exclusive;
                passedMax = this.validateValueBeforeMax(this.pds.utils.dateToTime(this.modelValue), this.pds.utils.dateToTime(maxDateObj), exclusiveMax);
                if (!passedMax) {
                    var errorMsg = void 0;
                    if (exclusiveMax == null) {
                        errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['dateWidget.failedMaxDate'], this.pds.i18n.localizeDate(maxDateObj));
                    }
                    else {
                        errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['dateWidget.failedMaxDateExclusive'], this.pds.i18n.localizeDate(maxDateObj));
                    }
                    this.setError(errorMsg);
                    inputIsValid = false;
                }
            }
        }
        else {
            var errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['dateWidget.invalidDate']);
            this.setError(errorMsg);
        }
        if (inputIsValid) {
            this.clearError();
        }
        return inputIsValid;
    };
    return PdsDateWidget;
}(PdsAbstractInputWidget_1.PdsAbstractInputWidget));
exports.PdsDateWidget = PdsDateWidget;

//# sourceMappingURL=PdsDateWidget.js.map

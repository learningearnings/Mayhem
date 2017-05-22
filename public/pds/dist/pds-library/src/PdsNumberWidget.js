"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var PdsAbstractInputWidget_1 = require('./PdsAbstractInputWidget');
var isIntegerRegex = /^([-]?[0-9]*)?$/;
var PdsNumberWidget = (function (_super) {
    __extends(PdsNumberWidget, _super);
    function PdsNumberWidget() {
        _super.apply(this, arguments);
        this.is = 'pds-number-widget';
        this.properties = {
            dataIsinteger: String,
            dataMinlength: String,
            dataMaxlength: String,
            dataMaxvalue: String,
            dataMinvalue: String,
            dataMaxdecimals: String,
            dataMinvalue_exclusive: String,
            dataMaxvalue_exclusive: String,
            hasHadError: {
                value: false
            },
            name: String
        };
    }
    PdsNumberWidget.prototype.messageKeysUpdated = function () {
    };
    PdsNumberWidget.prototype.setValue = function (value, skip) {
        if (skip === void 0) { skip = false; }
        if (value == null) {
            value = '';
        }
        var inputEl = this.querySelector('input');
        if (inputEl != null && value !== inputEl.value) {
            inputEl.value = value;
        }
        if (skip !== true) {
            this.setModelValue(this.pds.i18n.deLocalizeNumber(value), true);
        }
    };
    ;
    PdsNumberWidget.prototype.setModelValue = function (modelValue, skip) {
        var ele = this.querySelector('input');
        if (ele != null && modelValue !== ele.modelValue) {
            ele.modelValue = modelValue;
            if (skip !== true) {
                this.setValue(this.pds.i18n.localizeNumber(modelValue), true);
            }
            return true;
        }
        return false;
    };
    ;
    PdsNumberWidget.prototype.isValidNumber = function () {
        return this.pds.i18n.isValidNumber(this.value);
    };
    ;
    PdsNumberWidget.prototype.validateIsInteger = function () {
        return isIntegerRegex.test(this.value);
    };
    ;
    PdsNumberWidget.prototype.validateWidget = function () {
        var inputIsValid = true;
        if (this.value == null || this.value === '') {
        }
        else {
            inputIsValid = this.isValidNumber();
            if (inputIsValid) {
                this.setValue(this.value);
                var isInteger = (this.dataIsinteger === 'true');
                var passedIntCheck = this.validateIsInteger();
                if (isInteger && !passedIntCheck) {
                    var errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['numWidget.notAnInteger']);
                    this.setError(errorMsg);
                    inputIsValid = false;
                }
                var checkMinLength = this.dataMinlength != null;
                if (checkMinLength) {
                    var passedMinLength = this.value.length >= parseInt(this.dataMinlength);
                    if (!passedMinLength) {
                        var errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['numWidget.failedMinlength'], this.dataMinlength);
                        this.setError(errorMsg);
                        inputIsValid = false;
                    }
                }
                var checkMaxLength = this.dataMaxlength != null;
                if (checkMaxLength) {
                    var passedMaxLength = this.value.length <= parseInt(this.dataMaxlength);
                    if (!passedMaxLength) {
                        var errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['numWidget.failedMaxlength'], this.dataMaxlength);
                        this.setError(errorMsg);
                        inputIsValid = false;
                    }
                }
                var value = this.modelValue;
                var minValue = this.dataMinvalue;
                var passedMin = true;
                var passedMax = true;
                if (minValue != null) {
                    var exclusiveMin = this.dataMinvalue_exclusive;
                    passedMin = this.validateValueAfterMin(value, parseFloat(minValue), exclusiveMin);
                    if (!passedMin) {
                        var errorMsg = void 0;
                        if (exclusiveMin == null) {
                            errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['numWidget.failedMinValue'], this.pds.i18n.localizeNumber(minValue));
                        }
                        else {
                            errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['numWidget.failedMinValueExclusive'], this.pds.i18n.localizeNumber(minValue));
                        }
                        this.setError(errorMsg);
                        inputIsValid = false;
                    }
                }
                var maxValue = this.dataMaxvalue;
                if (passedMin) {
                    if (maxValue != null) {
                        var exclusiveMax = this.dataMaxvalue_exclusive;
                        if (!this.validateValueBeforeMax(value, parseFloat(maxValue), exclusiveMax)) {
                            var errorMsg = void 0;
                            if (exclusiveMax == null) {
                                errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['numWidget.failedMaxValue'], this.pds.i18n.localizeNumber(maxValue));
                            }
                            else {
                                errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['numWidget.failedMinValueExclusive'], this.pds.i18n.localizeNumber(maxValue));
                            }
                            this.setError(errorMsg);
                            inputIsValid = false;
                        }
                    }
                }
                var checkMaxDecimals = this.dataMaxdecimals != null;
                if (inputIsValid && checkMaxDecimals) {
                    var passedMaxDecimals = this.validateMaxDecimals(this.value);
                    if (!passedMaxDecimals) {
                        var errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['numWidget.failedMaxdecimals'], this.dataMaxdecimals);
                        this.setError(errorMsg);
                        inputIsValid = false;
                    }
                }
            }
            else {
                var errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['numWidget.invalidNumber']);
                this.setError(errorMsg);
            }
        }
        if (inputIsValid) {
            this.clearError();
        }
        return inputIsValid;
    };
    ;
    PdsNumberWidget.prototype.validateMaxDecimals = function (value) {
        if (value == null) {
            value = this.modelValue;
        }
        else {
            value = this.pds.i18n.deLocalizeNumber(value);
        }
        var maxDecimals = parseInt(this.dataMaxdecimals);
        return (this.countDecimals(value) <= maxDecimals);
    };
    PdsNumberWidget.prototype.countDecimals = function (value) {
        if ((value % 1) === 0) {
            return 0;
        }
        return value.toString().split('.')[1].length;
    };
    ;
    return PdsNumberWidget;
}(PdsAbstractInputWidget_1.PdsAbstractInputWidget));
exports.PdsNumberWidget = PdsNumberWidget;

//# sourceMappingURL=PdsNumberWidget.js.map

"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var PdsAbstractInputWidget_1 = require('./PdsAbstractInputWidget');
var PdsTextWidget = (function (_super) {
    __extends(PdsTextWidget, _super);
    function PdsTextWidget() {
        _super.apply(this, arguments);
        this.is = 'pds-text-widget';
        this.properties = {
            name: String,
            dataLabelText: String,
            dataBadgeText: String,
            dataHelperText: String,
            dataRegexErrorText: String,
            dataFieldHelpText: String,
            dataPlaceholderText: String,
            dataTooltipText: String,
            dataInputType: {
                type: String,
                value: 'text'
            },
            dataRegex: {
                type: String,
                observer: 'setValidationRegex',
                notify: true
            },
            dataMinlength: String,
            dataMaxlength: String,
            dataExcludechars: String,
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
            dataAdditionalInputAttributes: Object,
            dataAdditionalErrorAttributes: Object,
            dataHideUnelevatedBadge: {
                type: Boolean,
                value: false
            },
            dataDisableInvalidBadgeElevation: {
                type: Boolean,
                value: false
            }
        };
    }
    PdsTextWidget.prototype.messageKeysUpdated = function () {
    };
    PdsTextWidget.prototype.attached = function () {
        _super.prototype.attached.call(this);
        this.setReadonly();
        this.setRequired();
        this.setOriginalBadgeText();
        this.setShowBadge(this.dataHideUnelevatedBadge, this.dataBadgeText);
        this.setValidationRegex(false);
    };
    PdsTextWidget.prototype.ready = function () {
        this.setAdditionalInputAttributes();
        this.setAdditionalErrorAttributes();
    };
    PdsTextWidget.prototype.setAdditionalInputAttributes = function () {
        if (this.dataAdditionalInputAttributes != null) {
            var inputElement = this.querySelector('input');
            for (var key in this.dataAdditionalInputAttributes) {
                if (this.dataAdditionalInputAttributes.hasOwnProperty(key)) {
                    inputElement.setAttribute(key, this.dataAdditionalInputAttributes[key]);
                }
            }
        }
    };
    PdsTextWidget.prototype.setAdditionalErrorAttributes = function () {
        if (this.dataAdditionalErrorAttributes != null) {
            var errorElement = this.querySelector('.pds-validation');
            for (var key in this.dataAdditionalErrorAttributes) {
                if (this.dataAdditionalErrorAttributes.hasOwnProperty(key)) {
                    errorElement.setAttribute(key, this.dataAdditionalErrorAttributes[key]);
                }
            }
        }
    };
    PdsTextWidget.prototype.showLabel = function (dataLabelText) {
        return (dataLabelText != null && dataLabelText.length > 0);
    };
    PdsTextWidget.prototype.setOriginalBadgeText = function () {
        if (this.dataBadgeText != null) {
            this.originalBadgeText = this.dataBadgeText;
        }
    };
    PdsTextWidget.prototype.setValue = function (value, skip) {
        if (skip === void 0) { skip = false; }
        if (value == null) {
            value = '';
        }
        var inputEl = this.querySelector('input');
        if (inputEl != null && value !== inputEl.value) {
            inputEl.value = value;
        }
        if (skip !== true) {
            this.setModelValue(value, true);
        }
    };
    PdsTextWidget.prototype.setModelValue = function (modelValue, skip) {
        var ele = this.querySelector('input');
        if (ele != null && modelValue !== ele.modelValue) {
            ele.modelValue = modelValue;
            if (skip !== true) {
                this.setValue(modelValue, true);
            }
            return true;
        }
        return false;
    };
    PdsTextWidget.prototype.validateWidget = function () {
        var inputIsValid = true;
        var textToValidate = this.value;
        var fieldBadge = this.querySelector('.pds-field-badge');
        inputIsValid = this.validateIsRequired(inputIsValid, this.dataIsrequired, textToValidate, fieldBadge, this.dataDisableInvalidBadgeElevation);
        if (this.value != null && this.value !== '') {
            inputIsValid = this.validateMinLength(inputIsValid, this.dataMinlength, textToValidate);
            inputIsValid = this.validateMaxLength(inputIsValid, this.dataMaxlength, textToValidate);
            inputIsValid = this.validateRegex(inputIsValid, this.validationRegex, textToValidate, this.dataRegexErrorText);
        }
        this.setIsValid(inputIsValid);
        if (inputIsValid) {
            this.clearError();
        }
        return inputIsValid;
    };
    PdsTextWidget.prototype.validateIsRequired = function (isValid, isRequired, inputText, fieldBadge, disableInvalidBadgeElevation) {
        if (isValid && isRequired) {
            if (inputText == null || inputText === '') {
                this.toggleFieldBadge(fieldBadge, true, !disableInvalidBadgeElevation);
                isValid = false;
                this.setIsValid(isValid);
            }
            else {
                this.toggleFieldBadge(fieldBadge, !this.dataHideUnelevatedBadge, false);
            }
        }
        return isValid;
    };
    PdsTextWidget.prototype.validateMinLength = function (isValid, minLength, inputText) {
        if (isValid) {
            var checkMinLength = minLength != null;
            if (checkMinLength) {
                var passedMinLength = inputText.length >= parseInt(minLength);
                if (!passedMinLength) {
                    var errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['textWidget.failedMinlength'], minLength);
                    this.setError(errorMsg);
                    isValid = false;
                }
            }
        }
        return isValid;
    };
    PdsTextWidget.prototype.validateMaxLength = function (isValid, maxLength, inputText) {
        if (isValid) {
            var checkMaxLength = maxLength != null;
            if (checkMaxLength) {
                var passedMaxLength = inputText.length <= parseInt(maxLength);
                if (!passedMaxLength) {
                    var errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['textWidget.failedMaxlength'], maxLength);
                    this.setError(errorMsg);
                    isValid = false;
                }
            }
        }
        return isValid;
    };
    PdsTextWidget.prototype.validateRegex = function (isValid, regex, inputText, regexErrorMessage) {
        if (isValid) {
            var checkRegex = regex != null;
            if (checkRegex) {
                if (!regex.test(inputText)) {
                    var errorMsg = '';
                    if (regexErrorMessage != null) {
                        errorMsg = regexErrorMessage;
                    }
                    else {
                        errorMsg = this.pds.i18n.getText(this.pds.i18n.widgetKeys['textWidget.failedRegex']);
                    }
                    this.setError(errorMsg);
                    isValid = false;
                }
            }
        }
        return isValid;
    };
    PdsTextWidget.prototype.setValidationRegex = function (validate) {
        if (validate === void 0) { validate = true; }
        if (this.dataRegex != null && this.dataRegex.length > 0) {
            this.validationRegex = new RegExp(this.dataRegex);
        }
        else {
            this.validationRegex = new RegExp('');
        }
        if (validate) {
            this.validateWidget();
        }
    };
    PdsTextWidget.prototype.handleKeypress = function (event, detail, sender) {
        if (this.dataExcludechars != null && this.dataExcludechars.length > 0) {
            var enteredCharacter = String.fromCharCode(event.keyCode);
            if (this.isExcludedCharacter(enteredCharacter, this.dataExcludechars)) {
                event.preventDefault();
                event.stopPropagation();
                return false;
            }
        }
        return true;
    };
    PdsTextWidget.prototype.isExcludedCharacter = function (enteredCharacter, excludedCharacters) {
        for (var i = 0; i < excludedCharacters.length; i++) {
            if (enteredCharacter === excludedCharacters[i]) {
                return true;
            }
        }
        return false;
    };
    PdsTextWidget.prototype.toggleTooltip = function () {
        return;
    };
    return PdsTextWidget;
}(PdsAbstractInputWidget_1.PdsAbstractInputWidget));
exports.PdsTextWidget = PdsTextWidget;

//# sourceMappingURL=PdsTextWidget.js.map

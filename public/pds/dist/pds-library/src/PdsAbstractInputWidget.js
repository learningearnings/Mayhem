"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var PdsWidget_1 = require('./PdsWidget');
var pdsUtils_1 = require('./pdsUtils');
var PdsAbstractInputWidget = (function (_super) {
    __extends(PdsAbstractInputWidget, _super);
    function PdsAbstractInputWidget() {
        _super.apply(this, arguments);
        this.errorMessage = '';
        this.hasHadError = false;
        this.isValid = true;
        this.showTooltip = false;
        this.showError = false;
        this.originalBadgeText = '';
    }
    PdsAbstractInputWidget.prototype.inputChange = function () {
        this.validateWidget();
        this.setValue(this.value);
        this.dispatchEvent(new Event('modelValueChange'));
    };
    PdsAbstractInputWidget.prototype.validateValueAfterMin = function (value, minValue, exclusive) {
        if (value != null && minValue != null) {
            if (value < minValue) {
                return false;
            }
            if (exclusive != null) {
                if (value <= minValue) {
                    return false;
                }
            }
        }
        return true;
    };
    PdsAbstractInputWidget.prototype.validateValueBeforeMax = function (value, maxValue, exclusive) {
        if (value != null && maxValue != null) {
            if (value > maxValue) {
                return false;
            }
            if (exclusive != null) {
                if (value >= maxValue) {
                    return false;
                }
            }
        }
        return true;
    };
    PdsAbstractInputWidget.prototype.setError = function (errorMsg) {
        if (errorMsg != null && errorMsg !== '') {
            this.errorMessage = errorMsg;
            this.setIsValid(false);
        }
        else {
            this.errorMessage = '';
            this.setIsValid(true);
        }
    };
    PdsAbstractInputWidget.prototype.setIsValid = function (isValid) {
        this.isValid = isValid;
    };
    PdsAbstractInputWidget.prototype.clearError = function () {
        this.errorMessage = '';
        this.setIsValid(true);
    };
    PdsAbstractInputWidget.prototype.errorClass = function (hasHadError, errorMessage) {
        if (hasHadError && ((errorMessage != null && errorMessage !== '') || !this.isValid)) {
            return 'error';
        }
    };
    PdsAbstractInputWidget.prototype.hasError = function () {
        return !this.isValid || (this.errorMessage != null && this.errorMessage !== '');
    };
    PdsAbstractInputWidget.prototype.focusLost = function () {
        if (this.hasError()) {
            this.hasHadError = true;
        }
    };
    Object.defineProperty(PdsAbstractInputWidget.prototype, "value", {
        get: function () {
            var result = this.querySelector('input');
            if (result != null) {
                return result.value;
            }
        },
        set: function (value) {
            this.setValue(value);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(PdsAbstractInputWidget.prototype, "modelValue", {
        get: function () {
            var result = this.querySelector('input');
            if (result != null) {
                return result.modelValue;
            }
        },
        set: function (value) {
            var modelValueChanged = this.setModelValue(value);
            if (modelValueChanged) {
                this.validateWidget();
            }
        },
        enumerable: true,
        configurable: true
    });
    PdsAbstractInputWidget.prototype.attached = function () {
        var valueAttr = this.getAttribute('value');
        if (valueAttr != null) {
            this.value = valueAttr;
            this.removeAttribute('value');
        }
    };
    PdsAbstractInputWidget.prototype.getBadgeClasses = function (dataHideUnelevatedBadge, dataBadgeText) {
        this.setShowBadge(dataHideUnelevatedBadge, dataBadgeText);
        var showTheBadge = this.showBadge;
        var classes = 'pds-field-badge';
        if (!showTheBadge) {
            classes += ' pds-is-hidden';
        }
        return classes;
    };
    PdsAbstractInputWidget.prototype.setShowBadge = function (dataHideUnelevatedBadge, dataBadgeText) {
        this.showBadge = (!dataHideUnelevatedBadge && dataBadgeText != null && dataBadgeText.length > 0);
    };
    PdsAbstractInputWidget.prototype.setShowErrorMessage = function () {
        this.showError = this.hasHadError && this.errorMessage !== '';
    };
    PdsAbstractInputWidget.prototype.setRequired = function () {
        if (this.dataIsrequired != null) {
            var outerDiv = this.querySelector('div.pds-input-text');
            if (this.dataIsrequired) {
                this.querySelector('input').setAttribute('required', 'required');
                pdsUtils_1.pdsUtils.addClass(outerDiv, 'pds-is-required');
                if (!outerDiv.parentElement.hasAttribute('data-badge-text')) {
                    this.dataBadgeText = this.pds.i18n.getText(this.pds.i18n.widgetKeys['textWidget.required']);
                }
            }
            else {
                this.querySelector('input').removeAttribute('required', 'required');
                pdsUtils_1.pdsUtils.removeClass(outerDiv, 'pds-is-required');
                if (this.originalBadgeText != null && this.originalBadgeText !== '') {
                    this.dataBadgeText = this.originalBadgeText;
                }
                if (this.getBadgeClasses != null) {
                    pdsUtils_1.pdsUtils.addClass(this.querySelector('.pds-field-badge'), this.getBadgeClasses(this.dataHideUnelevatedBadge, this.dataBadgeText));
                }
            }
        }
    };
    PdsAbstractInputWidget.prototype.setReadonly = function () {
        if (this.dataIsreadonly != null && this.value != null) {
            var outerDiv = this.querySelector('div.pds-input-text');
            if (this.dataIsreadonly || this.dataIsreadonly.toString().toLowerCase() !== 'false') {
                pdsUtils_1.pdsUtils.addClass(outerDiv, 'pds-is-readonly');
                this.querySelector('.pds-readonly-data').innerText = this.value;
            }
            else {
                pdsUtils_1.pdsUtils.removeClass(outerDiv, 'pds-is-readonly');
                this.querySelector('.pds-readonly-data').innerText = '';
            }
        }
    };
    PdsAbstractInputWidget.prototype.showLabel = function (dataLabelText) {
        return (dataLabelText != null && dataLabelText.length > 0);
    };
    PdsAbstractInputWidget.prototype.showFieldHelp = function (dataFieldHelpText) {
        return (this.dataTooltipText != null && this.dataTooltipText.length > 0);
    };
    PdsAbstractInputWidget.prototype.showHelperText = function (dataHelperText) {
        return (this.dataHelperText != null && this.dataHelperText.length > 0);
    };
    PdsAbstractInputWidget.prototype.toggleFieldBadge = function (fieldBadge, showBadge, isElevated) {
        if (showBadge) {
            pdsUtils_1.pdsUtils.removeClass(fieldBadge, 'pds-is-hidden');
        }
        else {
            pdsUtils_1.pdsUtils.addClass(fieldBadge, 'pds-is-hidden');
        }
        if (isElevated != null) {
            this.elevateFieldBadge(fieldBadge, isElevated);
        }
    };
    PdsAbstractInputWidget.prototype.elevateFieldBadge = function (fieldBadge, isElevated) {
        if (isElevated) {
            pdsUtils_1.pdsUtils.addClass(fieldBadge, 'pds-is-elevated');
        }
        else {
            pdsUtils_1.pdsUtils.removeClass(fieldBadge, 'pds-is-elevated');
        }
    };
    return PdsAbstractInputWidget;
}(PdsWidget_1.PdsWidget));
exports.PdsAbstractInputWidget = PdsAbstractInputWidget;

//# sourceMappingURL=PdsAbstractInputWidget.js.map

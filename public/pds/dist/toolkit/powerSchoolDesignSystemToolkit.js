/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var PdsDateWidget_1 = __webpack_require__(1);
	var PdsDateWidgetDialog_1 = __webpack_require__(5);
	var PdsDynamicSelect_1 = __webpack_require__(6);
	var PdsTextWidget_1 = __webpack_require__(7);
	var PdsNumberWidget_1 = __webpack_require__(8);
	var pdsLogger_1 = __webpack_require__(9);
	var pdsI18n_1 = __webpack_require__(10);
	var pdsUtils_1 = __webpack_require__(4);
	var pdsValidation_1 = __webpack_require__(11);
	var PdsAppSwitcherWidget_1 = __webpack_require__(12);
	var PdsNumberedSlider_1 = __webpack_require__(13);
	var PdsNaturalSort_1 = __webpack_require__(14);
	var powerSchoolDesignSystemToolkit;
	var w = window;
	if (w.powerSchoolDesignSystemToolkit == null) {
	    var getPropertyDescriptor_1 = function (object, prop) {
	        var objectDescriptor = Object.getOwnPropertyDescriptor(object, prop);
	        if (objectDescriptor == null) {
	            return getPropertyDescriptor_1(Object.getPrototypeOf(object), prop);
	        }
	        else {
	            return objectDescriptor;
	        }
	    };
	    var createFlattenedPolymerDefinition = function (token) {
	        var tsObject = new token();
	        var definition = {};
	        var objectDef;
	        for (var prop in tsObject) {
	            objectDef = getPropertyDescriptor_1(tsObject, prop);
	            if (objectDef != null && objectDef.hasOwnProperty('get')) {
	                Object.defineProperty(definition, prop, objectDef);
	            }
	            else {
	                definition[prop] = tsObject[prop];
	            }
	        }
	        delete definition.querySelector;
	        delete definition.dispatchEvent;
	        return definition;
	    };
	    var powerSchoolDesignSystemToolkit_1 = {
	        i18n: pdsI18n_1.pdsI18n,
	        validation: pdsValidation_1.pdsValidation,
	        utils: pdsUtils_1.pdsUtils,
	        logger: pdsLogger_1.pdsLogger,
	        log: pdsLogger_1.pdsLogger.log,
	        naturalSort: new PdsNaturalSort_1.PdsNaturalSort,
	        naturalSortConstructor: PdsNaturalSort_1.PdsNaturalSort,
	        _pdsWidgetDefinitions: {
	            pdsTextWidgetDefinition: createFlattenedPolymerDefinition(PdsTextWidget_1.PdsTextWidget),
	            pdsNumberWidgetDefinition: createFlattenedPolymerDefinition(PdsNumberWidget_1.PdsNumberWidget),
	            pdsDateWidgetDefinition: createFlattenedPolymerDefinition(PdsDateWidget_1.PdsDateWidget),
	            pdsDateWidgetDialogDefinition: createFlattenedPolymerDefinition(PdsDateWidgetDialog_1.PdsDateWidgetDialog),
	            pdsDynamicSelectDefinition: createFlattenedPolymerDefinition(PdsDynamicSelect_1.PdsDynamicSelect),
	            pdsAppSwitcherDefinition: createFlattenedPolymerDefinition(PdsAppSwitcherWidget_1.PdsAppSwitcherWidget),
	            pdsNumberedSliderDefinition: createFlattenedPolymerDefinition(PdsNumberedSlider_1.PdsNumberedSlider)
	        }
	    };
	    powerSchoolDesignSystemToolkit_1.naturalSort.ignoreCase();
	    for (var prop in powerSchoolDesignSystemToolkit_1) {
	        if (prop !== '_pdsWidgetDefinitions') {
	            powerSchoolDesignSystemToolkit_1[prop].pds = powerSchoolDesignSystemToolkit_1;
	        }
	    }
	    for (var prop in powerSchoolDesignSystemToolkit_1._pdsWidgetDefinitions) {
	        if (prop !== '_pdsWidgetDefinitions') {
	            powerSchoolDesignSystemToolkit_1._pdsWidgetDefinitions[prop].pds = powerSchoolDesignSystemToolkit_1;
	        }
	    }
	    if (w.powerSchoolDesignSystemToolkit == null) {
	        w.powerSchoolDesignSystemToolkit = powerSchoolDesignSystemToolkit_1;
	    }
	}
	else {
	    powerSchoolDesignSystemToolkit = w.powerSchoolDesignSystemToolkit;
	}
	Object.defineProperty(exports, "__esModule", { value: true });
	exports.default = powerSchoolDesignSystemToolkit;
	


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsAbstractInputWidget_1 = __webpack_require__(2);
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
	


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var pdsUtils_1 = __webpack_require__(4);
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
	


/***/ },
/* 3 */
/***/ function(module, exports) {

	"use strict";
	var PdsWidget = (function () {
	    function PdsWidget() {
	    }
	    PdsWidget.prototype.ready = function () {
	        this.addMessageKeyUpdatedClass();
	    };
	    PdsWidget.prototype.addMessageKeyUpdatedClass = function () {
	        if (!this.pds.i18n.isUpdatedMessageKeys) {
	            this.className += 'default-messages';
	        }
	    };
	    PdsWidget.prototype.removeMessgeKeyUpdatedClass = function () {
	        if (this.pds.i18n.isUpdatedMessageKeys) {
	            this.className = this.className.replace('default-messages', '');
	        }
	    };
	    PdsWidget.prototype.querySelector = function (param) {
	        console.error('this should never have been called');
	    };
	    PdsWidget.prototype.dispatchEvent = function (e) {
	        console.error('this should never have been called');
	    };
	    return PdsWidget;
	}());
	exports.PdsWidget = PdsWidget;
	


/***/ },
/* 4 */
/***/ function(module, exports) {

	"use strict";
	exports.pdsUtils = {
	    pds: undefined,
	    ESCAPE_USER_INPUT_REGEX: /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g,
	    escapeUserInput: function (userInput) {
	        if (userInput == null) {
	            return userInput;
	        }
	        return userInput.replace(this.ESCAPE_USER_INPUT_REGEX, '\\$&');
	    },
	    isMobile: function () {
	        return window.orientation != null;
	    },
	    dateToTime: function (date) {
	        if (date != null && typeof date.getTime === 'function') {
	            return date.getTime();
	        }
	    },
	    getClosest: function (element, selector) {
	        if (element == null || typeof element.matches !== 'function' || selector == null) {
	            return;
	        }
	        while (element != null) {
	            try {
	                if (element.matches(selector)) {
	                    return element;
	                }
	            }
	            catch (e) {
	                return;
	            }
	            element = element.parentElement;
	        }
	    },
	    is: function (element, selector) {
	        if (element == null || typeof element.matches !== 'function' || selector == null) {
	            return;
	        }
	        try {
	            return element.matches(selector);
	        }
	        catch (e) {
	            return;
	        }
	    },
	    addClass: function (element, className) {
	        if (element == null) {
	            return;
	        }
	        if (element.className == null || (typeof element.className === 'string' && element.className.length === 0)) {
	            element.className = className;
	        }
	        else if ((' ' + element.className + ' ').indexOf(' ' + className + ' ') === -1) {
	            element.className += ' ' + className;
	        }
	    },
	    removeClass: function (element, className) {
	        if (element == null || element.className == null) {
	            return;
	        }
	        if (className != null && typeof className === 'string' && className.length > 0) {
	            element.className = (' ' + element.className + ' ').replace(' ' + className + ' ', ' ').trim();
	        }
	    },
	    flatten: function (arry) {
	        var _this = this;
	        var result = [];
	        if (arry != null && arry instanceof Array) {
	            arry.forEach(function (arrayElement) {
	                if (arrayElement instanceof Array) {
	                    _this.flatten(arrayElement).forEach(function (flattenedElement) {
	                        result.push(flattenedElement);
	                    });
	                }
	                else {
	                    result.push(arrayElement);
	                }
	            });
	        }
	        return result;
	    },
	    generateDays: function (year, month, fillBlankDays) {
	        if (fillBlankDays === void 0) { fillBlankDays = false; }
	        var dateTimes = [];
	        var dateItr = new Date(year, month, 1);
	        var addBlanks = function (loopTimes, computeDates, ascending) {
	            var alterDate;
	            if (computeDates) {
	                if (ascending) {
	                    alterDate = new Date(year, month, -1 * loopTimes + 1);
	                }
	                else {
	                    alterDate = new Date(year, month + 1, 1);
	                }
	            }
	            var sizeModSeven;
	            for (var i = 0; i < loopTimes; i++) {
	                sizeModSeven = (dateTimes.length) % 7;
	                if (computeDates && alterDate != null) {
	                    dateTimes.push({
	                        dayNum: alterDate.getDate(),
	                        dateTimeNum: alterDate.getTime(),
	                        isWeekend: sizeModSeven === 0 || sizeModSeven === 6,
	                        isFilled: true
	                    });
	                    alterDate.setDate(alterDate.getDate() + 1);
	                }
	                else {
	                    dateTimes.push({
	                        isWeekend: sizeModSeven === 0 || sizeModSeven === 6,
	                        isFilled: true
	                    });
	                }
	            }
	        };
	        addBlanks(dateItr.getDay(), fillBlankDays, true);
	        var sizeModSeven;
	        do {
	            sizeModSeven = (dateTimes.length) % 7;
	            dateTimes.push({
	                dayNum: dateItr.getDate(),
	                dateTimeNum: dateItr.getTime(),
	                isWeekend: sizeModSeven === 0 || sizeModSeven === 6
	            });
	            dateItr.setDate(dateItr.getDate() + 1);
	        } while (dateItr.getMonth() === month);
	        if (dateTimes.length % 7 > 0) {
	            addBlanks(7 - (dateTimes.length % 7), fillBlankDays, false);
	        }
	        return dateTimes;
	    }
	};
	if (!Element.prototype.matches) {
	    Element.prototype.matches =
	        Element.prototype.matchesSelector ||
	            Element.prototype.mozMatchesSelector ||
	            Element.prototype.msMatchesSelector ||
	            Element.prototype.oMatchesSelector ||
	            Element.prototype.webkitMatchesSelector ||
	            function (s) {
	                var matches = (this.document || this.ownerDocument).querySelectorAll(s), i = matches.length;
	                while (--i >= 0 && matches.item(i) !== this) {
	                }
	                return i > -1;
	            };
	}
	


/***/ },
/* 5 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
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
	


/***/ },
/* 6 */
/***/ function(module, exports) {

	"use strict";
	var PdsDynamicSelect = (function () {
	    function PdsDynamicSelect() {
	        this.is = 'pds-dynamic-select';
	        this.extends = 'select';
	        this.properties = {
	            dynamicOptions: {
	                observer: 'optionsUpdated'
	            },
	            defaultValue: {}
	        };
	        this.dynamicOptions = [];
	        this.defaultUsed = false;
	    }
	    PdsDynamicSelect.prototype.optionsUpdated = function () {
	        var testValue;
	        if (this.defaultUsed) {
	            testValue = this.value;
	        }
	        else {
	            testValue = this.defaultValue;
	            this.defaultUsed = true;
	        }
	        if (testValue == null) {
	            testValue = this.value;
	        }
	        this.innerHTML = '';
	        for (var i = 0; i < this.dynamicOptions.length; i++) {
	            var option = this.dynamicOptions[i];
	            var optionEle = document.createElement('option');
	            optionEle.value = option.value;
	            optionEle.innerText = option.text;
	            if (option.value === testValue) {
	                optionEle.setAttribute('selected', '');
	            }
	            else {
	                optionEle.removeAttribute('selected');
	            }
	            this.appendChild(optionEle);
	        }
	    };
	    return PdsDynamicSelect;
	}());
	exports.PdsDynamicSelect = PdsDynamicSelect;
	


/***/ },
/* 7 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsAbstractInputWidget_1 = __webpack_require__(2);
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
	


/***/ },
/* 8 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsAbstractInputWidget_1 = __webpack_require__(2);
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
	


/***/ },
/* 9 */
/***/ function(module, exports) {

	"use strict";
	exports.pdsLogger = {
	    setLoggerStatus: function (loggerName, showMessages) {
	        this.loggerStatus[loggerName] = showMessages;
	    },
	    loggerStatus: {},
	    requiresLogger: function (functionName) {
	        if (this.log[functionName] == null) {
	            var loggerFunction = function (msg) {
	                var params = [];
	                for (var _i = 1; _i < arguments.length; _i++) {
	                    params[_i - 1] = arguments[_i];
	                }
	                if (this.loggerStatus[functionName]) {
	                    console.log.apply(console, arguments);
	                }
	            };
	            this.log[functionName] = loggerFunction.bind(this);
	            if (!this.loggerStatus.hasOwnProperty(functionName)) {
	                this.loggerStatus[functionName] = false;
	            }
	        }
	    },
	    log: function (msg) {
	        var params = [];
	        for (var _i = 1; _i < arguments.length; _i++) {
	            params[_i - 1] = arguments[_i];
	        }
	        if (this.loggerStatus.log) {
	            console.log.apply(console, arguments);
	        }
	    }
	};
	


/***/ },
/* 10 */
/***/ function(module, exports) {

	"use strict";
	var formatNumber = function (format, number) {
	    var ds = format.ds;
	    var result = '';
	    if (isNaN(number) || number == null) {
	        if (number == null) {
	            return;
	        }
	        return String(number);
	    }
	    else {
	        result = number.toString();
	        result = result.replace('.', ds);
	        return result;
	    }
	};
	var padZeros = function (number, padding) {
	    var paddedString = '';
	    if (isNaN(number) || isNaN(padding) || number == null || padding == null) {
	        if (number == null) {
	            return;
	        }
	        return String(number);
	    }
	    else {
	        paddedString = number.toString();
	        while (paddedString.length < padding) {
	            paddedString = '0' + paddedString;
	        }
	        return paddedString;
	    }
	};
	exports.pdsI18n = {
	    setLocaleAndWidgetKeys: function (locale, widgetKeys) {
	        this.locale = locale;
	        if (widgetKeys != null) {
	            for (var key in widgetKeys) {
	                this.widgetKeys[key] = widgetKeys[key];
	            }
	        }
	        this.isUpdatedMessageKeys = true;
	        var elements = document.querySelectorAll('.default-messages');
	        elements.forEach(function (element) {
	            if (typeof element.messageKeysUpdated === 'function') {
	                element.messageKeysUpdated();
	                element.removeMessgeKeyUpdatedClass();
	            }
	        });
	    },
	    isUpdatedMessageKeys: false,
	    twoDigitRegex: /^\d{2}$/,
	    pds: undefined,
	    messageKeys: {},
	    widgetKeys: {
	        'numWidget.tooLarge': 'Too Large',
	        'numWidget.notAnInteger': 'Not an Integer',
	        'numWidget.invalidNumber': 'Not a Valid Number',
	        'numWidget.failedMinlength': 'Number must be at least {{arg0}} digits in length',
	        'numWidget.failedMaxdecimals': 'Number cannot have more than {{arg0}} decimal places',
	        'numWidget.failedMinValue': 'Number cannot be less than {{arg0}}',
	        'numWidget.failedMaxValue': 'Number cannot be greater than {{arg0}}',
	        'numWidget.failedMinValueExclusive': 'Number cannot be less than or equal to {{arg0}}',
	        'numWidget.failedMaxValueExclusive': 'Number cannot be greater than or equal to {{arg0}}',
	        'dateWidget.invalidDate': 'Not a Valid Date',
	        'dateWidget.failedMinDate': 'Date cannot be before {{arg0}}',
	        'dateWidget.failedMaxDate': 'Date cannot be after {{arg0}}',
	        'dateWidget.failedMinDateExclusive': 'Date cannot be on or before {{arg0}}',
	        'dateWidget.failedMaxDateExclusive': 'Date cannot be on or after {{arg0}}',
	        'dateWidget.open_picker_dialog': 'Open Date Picker',
	        'textWidget.failedMinlength': 'Text must be at least {{arg0}} characters in length',
	        'textWidget.failedMaxlength': 'Text must not be greater than {{arg0}} characters in length',
	        'textWidget.failedRegex': 'Text does not match required pattern',
	        'textWidget.required': 'required'
	    },
	    locale: {
	        'LOCALE': 'en_US',
	        'DATETIME_FORMATS': {
	            'MONTH': ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
	            'SHORTMONTH': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
	            'medium': 'MM/dd/yyyy hh:mm:ss a',
	            'mediumDateText': 'MM/DD/YYYY',
	            'shortDateText': 'MM/DD/YY',
	            'AMPMS': ['AM', 'PM'],
	            'mediumDate': 'MM/dd/yyyy',
	            'mediumTime': 'hh:mm:ss a',
	            'shortTime': 'hh:mm a',
	            'short': 'M/d/yy hh:mm a',
	            'SHORTDAY': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
	            'DAY': ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
	            'shortDate': 'M/d/yy'
	        },
	        '$BREACH_MITIGATION': 'XRFmEENA55t627cN',
	        'NUMBER_FORMATS': {
	            'DECIMAL_SEP': '.',
	            'number_regex': '([-]?(([0-9]{1,3}(,[0-9]{3})*(\\.[0-9]+)?|\\.[0-9]+)|([0-9]*(\\.[0-9]+)?)))',
	            'CURRENCY_SYM': '$',
	            'GROUP_SEP': ',',
	            'PATTERNS': [{
	                    'negSuf': '',
	                    'posSuf': '',
	                    'lgSize': '3',
	                    'minFrac': 0,
	                    'minInt': 1,
	                    'negPre': '-',
	                    'gSize': 3,
	                    'maxFrac': 9,
	                    'macFrac': '0',
	                    'posPre': ''
	                }],
	            'number_format': '#,###.#########'
	        }
	    },
	    overWriteGetText: function (getTextOverwriteFunction) {
	        this.getTextOverwriteFunction = getTextOverwriteFunction;
	    },
	    getShortFormat: function () {
	        return this.locale.DATETIME_FORMATS.shortDate;
	    }, getDateFormat: function () {
	        return this.locale.DATETIME_FORMATS.mediumDate;
	    }, getDateText: function () {
	        return this.locale.DATETIME_FORMATS.mediumDateText;
	    },
	    getText: function (key, params) {
	        if (this.getTextOverwriteFunction != null) {
	            return this.getTextOverwriteFunction(key, params);
	        }
	        if (typeof key !== 'string') {
	            return;
	        }
	        var msg = this.messageKeys[key];
	        if (msg == null) {
	            msg = key;
	        }
	        if (params != null) {
	            if (!(params instanceof Array)) {
	                params = [params];
	            }
	            if (params.length > 0) {
	                for (var i = 0; i < params.length; i++) {
	                    var token = '{{arg' + i + '}}';
	                    msg = msg.replace(token, String(params[i]));
	                }
	            }
	        }
	        return msg;
	    },
	    localizeDate: function (d, fmt) {
	        if (d == null) {
	            return '';
	        }
	        if (!this.isValidDateObject(d)) {
	            return String(d);
	        }
	        var seperator = this.locale.DATETIME_FORMATS.mediumDate.match(/[^A-Za-z]/);
	        var patternPieces = this.locale.DATETIME_FORMATS.mediumDate.split(seperator[0]);
	        var localizedStrings = [];
	        for (var i = 0; i < 3; i++) {
	            switch (patternPieces[i]) {
	                case 'd':
	                    localizedStrings.push(d.getDate());
	                    break;
	                case 'dd':
	                    localizedStrings.push(d.getDate());
	                    break;
	                case 'M':
	                    localizedStrings.push(d.getMonth() + 1);
	                    break;
	                case 'MM':
	                    localizedStrings.push(d.getMonth() + 1);
	                    break;
	                case 'yy':
	                    if (fmt !== 'mmdd') {
	                        localizedStrings.push(d.getFullYear());
	                    }
	                    break;
	                case 'yyyy':
	                    if (fmt !== 'mmdd') {
	                        localizedStrings.push(d.getFullYear());
	                    }
	                    break;
	                default:
	                    console.error('Unexpected format while localizing date');
	            }
	        }
	        return localizedStrings.join(seperator);
	    },
	    deLocalizeDate: function (localizedDateString) {
	        if (localizedDateString == null || localizedDateString === '') {
	            return;
	        }
	        var seperator = this.locale.DATETIME_FORMATS.mediumDate.match(/[^A-Za-z]/);
	        var patternPieces = this.locale.DATETIME_FORMATS.mediumDate.split(seperator[0]);
	        var localizedPieces = localizedDateString.split(seperator);
	        if (localizedPieces.length === 3) {
	            var day = void 0;
	            var month = void 0;
	            var year = void 0;
	            for (var i = 0; i < 3; i++) {
	                switch (patternPieces[i]) {
	                    case 'd':
	                    case 'dd':
	                        day = localizedPieces[i];
	                        break;
	                    case 'M':
	                    case 'MM':
	                        month = localizedPieces[i];
	                        break;
	                    case 'yy':
	                    case 'yyyy':
	                        year = localizedPieces[i];
	                        if (this.twoDigitRegex.test(year)) {
	                            if (parseInt(year) > 50) {
	                                year = '19' + year;
	                            }
	                            else {
	                                year = '20' + year;
	                            }
	                        }
	                        break;
	                    default:
	                        console.error('Unexpected format when delocalizing date.');
	                }
	            }
	            var d = new Date(year, month - 1, day, 0, 0, 0);
	            if (this.isValidDateObject(d)) {
	                return d;
	            }
	        }
	    },
	    isValidDateObject: function (d) {
	        if (d instanceof Date) {
	            return !isNaN(d.getTime());
	        }
	        return false;
	    },
	    isValidDate: function (localizedDate) {
	        if (localizedDate !== '') {
	            var parsedDate = this.deLocalizeDate(localizedDate);
	            return this.isValidDateObject(parsedDate);
	        }
	        return true;
	    },
	    parseJsonDate: function (psJsonDateString, preserveTimeOfDay) {
	        if (psJsonDateString == null) {
	            return;
	        }
	        var year = 0;
	        var month = 0;
	        var date = 0;
	        var hours = 0;
	        var minutes = 0;
	        var seconds = 0;
	        var split = psJsonDateString.split('-');
	        if (split.length < 3) {
	            return;
	        }
	        var dayTimeOfDay = split[2].split(' ');
	        if (dayTimeOfDay.length === 2) {
	            split[2] = dayTimeOfDay[0];
	            if (preserveTimeOfDay) {
	                var timeOfDay = dayTimeOfDay[1].split(':');
	                if (timeOfDay.length === 3) {
	                    hours = parseInt(timeOfDay[0]);
	                    minutes = parseInt(timeOfDay[1]);
	                    seconds = parseInt(timeOfDay[2]);
	                }
	            }
	        }
	        year = parseInt(split[0]);
	        month = parseInt(split[1]) - 1;
	        date = parseInt(split[2]);
	        var returnDate = new Date(year, month, date, hours, minutes, seconds);
	        if (isNaN(returnDate.getTime())) {
	            return;
	        }
	        return returnDate;
	    },
	    getJsonDate: function (javascriptDateObject, preserveTimeOfDay) {
	        if (javascriptDateObject == null) {
	            return;
	        }
	        if (isNaN(javascriptDateObject.getTime())) {
	            return;
	        }
	        var psJsonDateString = javascriptDateObject.getFullYear() + '-' +
	            padZeros((javascriptDateObject.getMonth() + 1), 2) + '-' +
	            padZeros(javascriptDateObject.getDate(), 2);
	        if (preserveTimeOfDay) {
	            psJsonDateString += ' ' + padZeros(javascriptDateObject.getHours(), 2) + ':' +
	                padZeros(javascriptDateObject.getMinutes(), 2) + ':' +
	                padZeros(javascriptDateObject.getSeconds(), 2);
	        }
	        return psJsonDateString;
	    },
	    parseJsonDateToNonLocalized: function (psJsonDateString) {
	        var date = this.parseJsonDate(psJsonDateString);
	        return this.getMmDdYyyyDateString(date);
	    },
	    getMmDdYyyyDateString: function (date) {
	        return (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear();
	    },
	    addDaysToDate: function (date, numDays) {
	        date.setDate(date.getDate() + numDays);
	        return date;
	    },
	    getLocalizedDayOfWeek: function (date) {
	        return this.locale.DATETIME_FORMATS.DAY[date.getDay()];
	    },
	    getNumericFormat: function () {
	        return {
	            format: this.locale.NUMBER_FORMATS.number_format,
	            size: this.locale.NUMBER_FORMATS.PATTERNS[0].gSize,
	            gs: this.locale.NUMBER_FORMATS.GROUP_SEP,
	            ds: this.locale.NUMBER_FORMATS.DECIMAL_SEP,
	            regex: this.locale.NUMBER_FORMATS.number_regex
	        };
	    },
	    localizeNumber: function (number, decimalPlaces) {
	        if (number == null) {
	            return;
	        }
	        if (decimalPlaces != null && !isNaN(decimalPlaces)) {
	            var multiplier = 1;
	            for (var i = 0; i < decimalPlaces; i++) {
	                multiplier *= 10;
	            }
	            number = Math.round(number * multiplier) / multiplier;
	        }
	        return formatNumber(this.getNumericFormat(), number);
	    },
	    deLocalizeNumber: function (number) {
	        return this.removeNumberFormat(this.getNumericFormat(), number);
	    },
	    deLocalizeNumberToString: function (number) {
	        var result = this.removeNumberFormat(this.getNumericFormat(), number);
	        if (result == null) {
	            return;
	        }
	        return String(result);
	    },
	    removeNumberFormat: function (format, number) {
	        if (number == null) {
	            return;
	        }
	        var gsNotBlank = (format.gs === '.' || format.gs === ',' || format.gs === ' ');
	        number = number.toString();
	        var regexString = '^' + format.regex + '$';
	        var validNumber = new RegExp(regexString, 'g');
	        if (number !== '' && number.match(validNumber) != null) {
	            if (gsNotBlank) {
	                var gs = new RegExp('\\' + format.gs, 'g');
	                number = number.replace(gs, '');
	            }
	            var ds = new RegExp('\\' + format.ds, 'g');
	            number = parseFloat(number.replace(ds, '.'));
	        }
	        else {
	            return;
	        }
	        if (!isNaN(number)) {
	            return number;
	        }
	    },
	    isValidNumber: function (numValue) {
	        if (numValue !== '') {
	            var regexString = '^' + this.locale.NUMBER_FORMATS.number_regex + '$';
	            var regex = new RegExp(regexString, 'g');
	            if (regex.test(numValue)) {
	                return (this.deLocalizeNumber(numValue) != null);
	            }
	            else {
	                return false;
	            }
	        }
	        return true;
	    },
	    localizeNumericObject: function (object, key) {
	        object['_i18n_' + key] = this.localizeNumber(object[key]);
	    },
	    deLocalizeNumericObject: function (object, key) {
	        if (!object.hasOwnProperty('_i18n_' + key)) {
	            return;
	        }
	        if (object['_i18n_' + key] == null || object['_i18n_' + key] === '') {
	            object[key] = '';
	            return;
	        }
	        object[key] = this.deLocalizeNumber(object['_i18n_' + key]);
	    },
	    makeStrFromTime: function (time) {
	        var separator = ':';
	        var timeFormat = this.locale.DATETIME_FORMATS.shortTime;
	        var ampmNames = this.locale.DATETIME_FORMATS.AMPMS;
	        var show24Hours = (timeFormat === 'HH:mm') ? true : false;
	        var hours = time.getHours();
	        var mins = time.getMinutes();
	        var hoursString;
	        var minsString;
	        if (!show24Hours) {
	            hours = ((hours + 11) % 12) + 1;
	        }
	        if (hours < 10) {
	            hoursString = '0' + hours;
	        }
	        else {
	            hoursString = String(hours);
	        }
	        if (mins < 10) {
	            minsString = '0' + mins;
	        }
	        else {
	            minsString = String(mins);
	        }
	        return hours + separator + mins + (show24Hours ? '' : ' ' + ampmNames[time.getHours() < 12 ? 0 : 1]);
	    }
	};
	


/***/ },
/* 11 */
/***/ function(module, exports) {

	"use strict";
	exports.pdsValidation = {
	    pds: undefined,
	    validateElements: function (element) {
	        if (element == null) {
	            return true;
	        }
	        var allElementsAreValid = true;
	        var inputWidgets = element.querySelectorAll('pds-number-widget,pds-date-widget,pds-text-widget');
	        for (var i = 0; i < inputWidgets.length; i++) {
	            allElementsAreValid = inputWidgets[i].validateWidget() && allElementsAreValid;
	        }
	        return allElementsAreValid;
	    }
	};
	


/***/ },
/* 12 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var PdsAppSwitcherWidget = (function (_super) {
	    __extends(PdsAppSwitcherWidget, _super);
	    function PdsAppSwitcherWidget() {
	        _super.apply(this, arguments);
	        this.is = 'pds-app-switcher';
	        this.showApps = true;
	        this.classLookup = {
	            powerTeacher: 'pds-pt-icon-xxl',
	            powerTeacherPro: 'pds-ptp-icon-xxl',
	            learning: 'pds-learning-icon-xxl',
	            assessment: 'pds-assessment-icon-xxl',
	            specialEducation: 'pds-sped-icon-xxl'
	        };
	    }
	    PdsAppSwitcherWidget.prototype.messageKeysUpdated = function () {
	    };
	    PdsAppSwitcherWidget.prototype.getIconClass = function (classLookupKey) {
	        return this.classLookup[classLookupKey];
	    };
	    PdsAppSwitcherWidget.prototype.ready = function () {
	        var _this = this;
	        document.body.addEventListener('click', function (event) {
	            if (_this.showApps && !_this.pds.utils.getClosest(event.target, 'pds-apps-dropdown')) {
	                _this.close();
	            }
	        });
	        this.apps = [];
	        this.plugins = [];
	    };
	    PdsAppSwitcherWidget.prototype.openAppSwitcher = function (event) {
	        var _this = this;
	        event.preventDefault();
	        if (!this.showApps) {
	            setTimeout(function () {
	                _this.showApps = true;
	            }, 0);
	        }
	    };
	    PdsAppSwitcherWidget.prototype.close = function () {
	        this.showApps = false;
	    };
	    return PdsAppSwitcherWidget;
	}(PdsWidget_1.PdsWidget));
	exports.PdsAppSwitcherWidget = PdsAppSwitcherWidget;
	


/***/ },
/* 13 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var PdsNumberedSlider = (function (_super) {
	    __extends(PdsNumberedSlider, _super);
	    function PdsNumberedSlider() {
	        _super.apply(this, arguments);
	        this.is = 'pds-numbered-slider';
	        this.properties = {
	            min: Number,
	            max: {
	                type: Number,
	                observer: 'maxChanged'
	            },
	            value: {
	                type: Number,
	                observer: 'valueChanged'
	            },
	            name: String
	        };
	        this.updateNumber = function () {
	            var input = this.querySelector('input');
	            var i = 0;
	            var currentPage = parseInt(input.value);
	            var dotLabel = this.querySelector('span.pds-dot-label');
	            var dotBackground = this.querySelector('span.pds-dot-background');
	            var max = parseInt(this.max);
	            var min = parseInt(this.min);
	            var totalPages = max - min;
	            var offset = 34 * (currentPage - min) / totalPages;
	            var position = 100 * (currentPage - min) / totalPages;
	            var positionStyle = 'calc(' + position + '% - ' + offset + 'px)';
	            dotBackground.style.left = positionStyle;
	            dotLabel.style.left = positionStyle;
	            dotLabel.innerText = currentPage;
	        };
	    }
	    Object.defineProperty(PdsNumberedSlider.prototype, "modelValue", {
	        get: function () {
	            return this.value;
	        },
	        set: function (value) {
	            if (typeof value === 'string') {
	                value = parseInt(String(value));
	            }
	            this.value = value;
	            this.querySelector('input').value = value;
	        },
	        enumerable: true,
	        configurable: true
	    });
	    PdsNumberedSlider.prototype.valueChanged = function (value) {
	        this.querySelector('input').value = this.value;
	        this.updateNumber();
	    };
	    PdsNumberedSlider.prototype.maxChanged = function (max) {
	        this.querySelector('input').setAttribute('max', this.max);
	        this.updateNumber();
	    };
	    PdsNumberedSlider.prototype.attributeChanged = function (name, type) {
	        if (this.properties.hasOwnProperty(name)) {
	            this.querySelector('input').setAttribute(name, this[name]);
	        }
	    };
	    PdsNumberedSlider.prototype.ready = function () {
	        var input = this.querySelector('input');
	        input.setAttribute('min', this.getAttribute('min'));
	        input.setAttribute('max', this.getAttribute('max'));
	        input.setAttribute('value', this.value || this.getAttribute('value'));
	        var updateValueAndDispatchModelValueChange = function (event) {
	            this.value = parseInt(event.target.value);
	            var e = new Event('modelValueChange');
	            this.dispatchEvent(e);
	        };
	        input.addEventListener('mouseup', updateValueAndDispatchModelValueChange.bind(this));
	        input.addEventListener('touchend', updateValueAndDispatchModelValueChange.bind(this));
	        input.addEventListener('keyup', updateValueAndDispatchModelValueChange.bind(this));
	        input.addEventListener('input', this.updateNumber.bind(this));
	        input.addEventListener('change', this.updateNumber.bind(this));
	    };
	    PdsNumberedSlider.prototype.messageKeysUpdated = function () {
	    };
	    return PdsNumberedSlider;
	}(PdsWidget_1.PdsWidget));
	exports.PdsNumberedSlider = PdsNumberedSlider;
	


/***/ },
/* 14 */
/***/ function(module, exports) {

	"use strict";
	var hasValue = function (value) {
	    if (value == null) {
	        return false;
	    }
	    if (typeof value === 'number') {
	        if (isNaN(value)) {
	            return false;
	        }
	        return true;
	    }
	    if (typeof value === 'string') {
	        return value.trim().length > 0;
	    }
	    if (value === true || value === false) {
	        return true;
	    }
	    if (typeof value === 'function') {
	        return true;
	    }
	    if (typeof value === 'object') {
	        if ('length' in value) {
	            return value.length > 0;
	        }
	        if (value instanceof HTMLElement) {
	            return hasValue(value.value);
	        }
	        return true;
	    }
	    return false;
	};
	var naturalCompare = function (a, b) {
	    if (this.key != null) {
	        a = a[this.key];
	        b = b[this.key];
	    }
	    var alphabet = this.alphabet;
	    var ignoreCase = this.isIgnoreCase;
	    var isAscending = this.isAscending;
	    var result;
	    var i;
	    var codeA;
	    var codeB = 1;
	    var posA = 0;
	    var posB = 0;
	    var getCode = function (str, pos, code) {
	        if (code) {
	            for (i = pos; code = getCode(str, i), code < 76 && code > 65;) {
	                ++i;
	            }
	            return parseInt(str.slice(pos - 1, i), 10);
	        }
	        code = alphabet && alphabet.indexOf(str.charAt(pos));
	        return (hasValue(code) && code > -1) ? code + 76 : ((code = str.charCodeAt(pos) || 0), code < 45 || code > 127) ? code
	            : code < 46 ? 65
	                : code < 48 ? code - 1
	                    : code < 58 ? code + 18
	                        : code < 65 ? code - 11
	                            : code < 91 ? code + 11
	                                : code < 97 ? code - 37
	                                    : code < 123 ? code + 5
	                                        : code - 63;
	    };
	    var isPseudoNullA = false;
	    var isPseudoNullB = false;
	    if (this.emptyAsNull) {
	        isPseudoNullA = (a != null && !hasValue(a));
	        isPseudoNullB = (b != null && !hasValue(b));
	    }
	    if (a == null || b == null || isPseudoNullA || isPseudoNullB) {
	        var nulls = this.nulls;
	        if ((a === undefined && b === undefined) || (a === null && b === null)) {
	            result = 0;
	        }
	        else if (a === undefined) {
	            result = ((b === null || isPseudoNullB) ? -1 :
	                nulls === 'first' ? -1 :
	                    nulls === 'last' ? 1 :
	                        nulls === 'desc' ? (isAscending ? 1 : -1) :
	                            (isAscending ? -1 : 1));
	        }
	        else if (b === undefined) {
	            result = ((a === null || isPseudoNullA) ? 1 :
	                nulls === 'first' ? 1 :
	                    nulls === 'last' ? -1 :
	                        nulls === 'desc' ? (isAscending ? -1 : 1) :
	                            (isAscending ? 1 : -1));
	        }
	        else if (isPseudoNullA && isPseudoNullB) {
	            result = a.localeCompare(b);
	        }
	        else if (a === null || isPseudoNullA) {
	            result = (b === null ? 1 :
	                isPseudoNullB ? -1 :
	                    nulls === 'first' ? -1 :
	                        nulls === 'last' ? 1 :
	                            nulls === 'desc' ? (isAscending ? 1 : -1) :
	                                (isAscending ? -1 : 1));
	        }
	        else {
	            result = (nulls === 'first' ? 1 :
	                nulls === 'last' ? -1 :
	                    nulls === 'desc' ? (isAscending ? -1 : 1) :
	                        (isAscending ? 1 : -1));
	        }
	        return result;
	    }
	    if (a instanceof Date && b instanceof Date) {
	        a = a.getTime();
	        b = b.getTime();
	    }
	    else {
	        if (typeof a === 'string') {
	            var numA = parseFloat(a);
	            if (!isNaN(numA)) {
	                if (a === String(numA) && a.length === numA.toString().length) {
	                    a = numA;
	                }
	            }
	        }
	        if (typeof b === 'string') {
	            var numB = parseFloat(b);
	            if (!isNaN(numB)) {
	                if (b === String(numB) && b.length === numB.toString().length) {
	                    b = numB;
	                }
	            }
	        }
	    }
	    if (typeof a === 'number' && typeof b === 'number') {
	        result = (a === b ? 0 : (a < b) ? -1 : 1);
	        if (!isAscending) {
	            result *= -1;
	        }
	        return result;
	    }
	    else {
	        a += '';
	        b += '';
	        if (a !== b) {
	            if (ignoreCase) {
	                a = a.toLowerCase();
	                b = b.toLowerCase();
	            }
	            for (; codeB;) {
	                codeA = getCode(a, posA++);
	                codeB = getCode(b, posB++);
	                if (codeA < 76 && codeB < 76 && codeA > 66 && codeB > 66) {
	                    codeA = getCode(a, posA, posA);
	                    codeB = getCode(b, posB, posA = i);
	                    posB = i;
	                }
	                if (codeA !== codeB) {
	                    result = (codeA < codeB) ? -1 : 1;
	                    if (!isAscending) {
	                        result *= -1;
	                    }
	                    return result;
	                }
	            }
	        }
	        return 0;
	    }
	};
	var PdsNaturalSort = (function () {
	    function PdsNaturalSort() {
	        this.alphabet = null;
	        this.emptyAsNull = false;
	        this.isAscending = true;
	        this.isIgnoreCase = false;
	        this.key = null;
	        this.nulls = 'asc';
	        this.naturalCompare = naturalCompare.bind(this);
	    }
	    PdsNaturalSort.prototype.clearKey = function () {
	        this.key = null;
	    };
	    PdsNaturalSort.prototype.setAlphabet = function (str) {
	        this.alphabet = (hasValue(str) ? str : null);
	    };
	    PdsNaturalSort.prototype.setAscending = function (value) {
	        this.isAscending = value;
	    };
	    PdsNaturalSort.prototype.setEmptyAsNull = function (value) {
	        this.emptyAsNull = value;
	    };
	    PdsNaturalSort.prototype.setIgnoreCase = function (value) {
	        this.isIgnoreCase = value;
	    };
	    PdsNaturalSort.prototype.setKey = function (value) {
	        this.key = value;
	        if (value == null) {
	            console.warn('Invalid value for natural compare key: ', value);
	        }
	    };
	    PdsNaturalSort.prototype.setNulls = function (value) {
	        if (value == null || typeof value !== 'string') {
	            value = 'asc';
	        }
	        value = value.toLowerCase();
	        this.nulls = (value === 'desc' || value === 'first' || value === 'last' ? value : 'asc');
	    };
	    PdsNaturalSort.prototype.ascending = function () {
	        this.isAscending = true;
	    };
	    PdsNaturalSort.prototype.descending = function () {
	        this.isAscending = false;
	    };
	    PdsNaturalSort.prototype.ignoreCase = function () {
	        this.isIgnoreCase = true;
	    };
	    PdsNaturalSort.prototype.nullsAsc = function () {
	        this.nulls = 'asc';
	    };
	    PdsNaturalSort.prototype.nullsDesc = function () {
	        this.nulls = 'desc';
	    };
	    PdsNaturalSort.prototype.nullsFirst = function () {
	        this.nulls = 'first';
	    };
	    PdsNaturalSort.prototype.nullsLast = function () {
	        this.nulls = 'last';
	    };
	    PdsNaturalSort.prototype.useCase = function () {
	        this.isIgnoreCase = false;
	    };
	    PdsNaturalSort.prototype.reset = function () {
	        this.alphabet = null;
	        this.emptyAsNull = false;
	        this.isAscending = true;
	        this.isIgnoreCase = false;
	        this.nulls = 'asc';
	        this.clearKey();
	    };
	    PdsNaturalSort.prototype.naturalSort = function (arr, key) {
	        var result;
	        if (arr instanceof Array) {
	            var hasObject_1 = false;
	            var hasPrimitive_1 = false;
	            arr.forEach(function (o) {
	                if (o != null && typeof o === 'object') {
	                    hasObject_1 = true;
	                }
	                else {
	                    hasPrimitive_1 = true;
	                }
	            });
	            if (hasObject_1 && !hasPrimitive_1) {
	                this.setKey(key);
	                result = arr.sort(this.naturalCompare);
	            }
	            else if (!hasObject_1 && hasPrimitive_1) {
	                result = arr.slice().sort(this.naturalCompare);
	            }
	            else if (!hasObject_1 && !hasPrimitive_1) {
	                result = arr;
	            }
	            else {
	                throw 'Unable to sort an array containing both primitives and objects.';
	            }
	        }
	        else {
	            result = arr;
	        }
	        return result;
	    };
	    return PdsNaturalSort;
	}());
	exports.PdsNaturalSort = PdsNaturalSort;
	


/***/ }
/******/ ]);
//# sourceMappingURL=powerSchoolDesignSystemToolkit.js.map
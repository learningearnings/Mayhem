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
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var pds_date_widget_1 = __webpack_require__(1);
	var pds_date_widget_dialog_1 = __webpack_require__(4);
	var pds_app_nav_1 = __webpack_require__(6);
	var pds_class_block_1 = __webpack_require__(7);
	var pds_class_picker_1 = __webpack_require__(8);
	var PdsDynamicSelect_1 = __webpack_require__(9);
	var pds_text_widget_1 = __webpack_require__(10);
	var pds_number_widget_1 = __webpack_require__(11);
	var pdsLogger_1 = __webpack_require__(12);
	var pdsI18n_1 = __webpack_require__(13);
	var pdsUtils_1 = __webpack_require__(5);
	var pdsValidation_1 = __webpack_require__(14);
	var PdsAppSwitcherWidget_1 = __webpack_require__(15);
	var PdsNumberedSlider_1 = __webpack_require__(16);
	var PdsNaturalSort_1 = __webpack_require__(17);
	var pdsValidationRulesEngine_1 = __webpack_require__(18);
	var PdsProgressBarWidget_1 = __webpack_require__(22);
	var pds_reporting_term_selector_1 = __webpack_require__(23);
	var pds_search_1 = __webpack_require__(24);
	var PdsIcon_1 = __webpack_require__(25);
	var pds_rich_text_editor_1 = __webpack_require__(26);
	var pds_img_1 = __webpack_require__(28);
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
	        delete definition.hasAttribute;
	        return definition;
	    };
	    var pds = {
	        i18n: pdsI18n_1.pdsI18n,
	        validation: pdsValidation_1.pdsValidation,
	        utils: pdsUtils_1.pdsUtils,
	        logger: pdsLogger_1.pdsLogger,
	        log: pdsLogger_1.pdsLogger.log,
	        naturalSort: new PdsNaturalSort_1.PdsNaturalSort,
	        naturalSortConstructor: PdsNaturalSort_1.PdsNaturalSort,
	        validationEngine: pdsValidationRulesEngine_1.pdsValidationRulesEngine,
	        setAutomationChecker: function (automationChecker) {
	            if (this.automationChecker == null) {
	                this.automationChecker = automationChecker;
	                if (localStorage.getItem('debug') === 'true') {
	                    this.automationChecker.startChecking();
	                }
	            }
	            else {
	                console.error('The automation checker is already being downloaded in this app. To turn it on run localStorage.setItem(\'debug\', \'true\' and reload the page');
	            }
	        },
	        _pdsWidgetDefinitions: {
	            pdsTextWidgetDefinition: createFlattenedPolymerDefinition(pds_text_widget_1.PdsTextWidget),
	            pdsNumberWidgetDefinition: createFlattenedPolymerDefinition(pds_number_widget_1.PdsNumberWidget),
	            pdsDateWidgetDefinition: createFlattenedPolymerDefinition(pds_date_widget_1.PdsDateWidget),
	            pdsDateWidgetDialogDefinition: createFlattenedPolymerDefinition(pds_date_widget_dialog_1.PdsDateWidgetDialog),
	            pdsDynamicSelectDefinition: createFlattenedPolymerDefinition(PdsDynamicSelect_1.PdsDynamicSelect),
	            pdsAppSwitcherDefinition: createFlattenedPolymerDefinition(PdsAppSwitcherWidget_1.PdsAppSwitcherWidget),
	            pdsNumberedSliderDefinition: createFlattenedPolymerDefinition(PdsNumberedSlider_1.PdsNumberedSlider),
	            pdsIconDefinition: createFlattenedPolymerDefinition(PdsIcon_1.PdsIcon),
	            pdsAppNav: createFlattenedPolymerDefinition(pds_app_nav_1.PdsAppNav),
	            pdsClassBlock: createFlattenedPolymerDefinition(pds_class_block_1.PdsClassBlock),
	            pdsClassPicker: createFlattenedPolymerDefinition(pds_class_picker_1.PdsClassPicker),
	            pdsReportingTermSelector: createFlattenedPolymerDefinition(pds_reporting_term_selector_1.PdsReportingTermSelector),
	            pdsSearch: createFlattenedPolymerDefinition(pds_search_1.PdsSearch),
	            pdsRichTextEditor: createFlattenedPolymerDefinition(pds_rich_text_editor_1.PdsRichTextEditor),
	            pdsProgressBarWidgetDefinition: createFlattenedPolymerDefinition(PdsProgressBarWidget_1.PdsProgressBarWidget),
	            pdsImgWidgetDefinition: createFlattenedPolymerDefinition(pds_img_1.PdsImg)
	        },
	        svgSpritePath: '../../../../img/icons/pds-icons.svg'
	    };
	    pds.naturalSort.ignoreCase();
	    for (var prop in pds) {
	        if (prop !== '_pdsWidgetDefinitions' && prop !== 'svgSpritePath') {
	            pds[prop].pds = pds;
	        }
	    }
	    for (var prop in pds._pdsWidgetDefinitions) {
	        if (prop !== '_pdsWidgetDefinitions') {
	            pds._pdsWidgetDefinitions[prop].pds = pds;
	        }
	    }
	    if (w.powerSchoolDesignSystemToolkit == null) {
	        w.powerSchoolDesignSystemToolkit = pds;
	    }
	}
	powerSchoolDesignSystemToolkit = w.powerSchoolDesignSystemToolkit;
	Object.defineProperty(exports, "__esModule", { value: true });
	exports.default = powerSchoolDesignSystemToolkit;
	


/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var pds_abstract_input_widget_1 = __webpack_require__(2);
	var PdsDateWidget = (function (_super) {
	    __extends(PdsDateWidget, _super);
	    function PdsDateWidget() {
	        _super.apply(this, arguments);
	        this.is = 'pds-date-widget';
	        this.showDatePickerDialog = false;
	        this.properties = {
	            name: String,
	            dataLabelText: String,
	            dataBadgeText: {
	                type: String,
	                value: '',
	                observer: 'setUpBadge'
	            },
	            dataHelperText: {
	                type: String,
	                value: null
	            },
	            dataFieldHelpText: String,
	            dataPlaceholderText: String,
	            dataTooltipText: String,
	            dataIsreadonly: {
	                type: String,
	                value: 'false',
	                observer: 'setReadonlyText'
	            },
	            dataIsfieldonly: {
	                type: String,
	                value: 'false'
	            },
	            dataHideUnelevatedBadge: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataDisableInvalidBadgeElevation: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataIsrequired: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataMaxdate: String,
	            dataMindate: String,
	            dataCustomvalidate: String
	        };
	    }
	    PdsDateWidget.prototype.generateValidationRules = function () {
	        var validationRules = this.pds.validationEngine.getBasicValidationRules();
	        validationRules.isDate = true;
	        validationRules.setProperty('isRequired', this.dataIsrequired, Boolean);
	        validationRules.setProperty('maxValue', this.dataMaxdate, Date);
	        validationRules.setProperty('minValue', this.dataMindate, Date);
	        this.validators = this.pds.validationEngine.getValidatorsForRules(validationRules);
	        if ('dataCustomvalidate' in this) {
	            this.validators.push({
	                execute: this.pds.validation.getCustomValidate(this.dataCustomvalidate)
	            });
	        }
	    };
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
	    PdsDateWidget.prototype.messageKeysUpdated = function () {
	        this.buttonText = this.pds.i18n.getText(this.pds.i18n.widgetKeys['dateWidget.open_picker_dialog']);
	    };
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
	    PdsDateWidget.prototype.dateChanged = function (e) {
	        this.value = this.pds.i18n.localizeDate(e.target.value);
	        this.inputChange();
	        this.validateWidget(true);
	        this.closeDatePickerDialog();
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
	    return PdsDateWidget;
	}(pds_abstract_input_widget_1.PdsAbstractInputWidget));
	exports.PdsDateWidget = PdsDateWidget;
	


/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var PdsAbstractInputWidget = (function (_super) {
	    __extends(PdsAbstractInputWidget, _super);
	    function PdsAbstractInputWidget() {
	        _super.apply(this, arguments);
	    }
	    PdsAbstractInputWidget.prototype.attributeChanged = function () {
	        this.generateValidationRules();
	    };
	    PdsAbstractInputWidget.prototype.ready = function () {
	        this.errorMessage = '';
	        this.isValid = true;
	        this.invalidRule = '';
	        this.isAttached = false;
	        this.isBadgeElevated = false;
	        this.isBadgeHidden = true;
	        this.showTooltip = false;
	        this.canShowError = false;
	        this.originalBadgeText = '';
	        this.messageKeysUpdated();
	        this.generateValidationRules();
	    };
	    PdsAbstractInputWidget.prototype.inputChange = function () {
	        this.validateWidget();
	        this.setValue(this.value);
	        this.dispatchEvent(new Event('modelValueChange'));
	    };
	    PdsAbstractInputWidget.prototype.focusLost = function () {
	        this.validateWidget(true);
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
	            this.setReadonlyText();
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
	            this.setReadonlyText();
	        },
	        enumerable: true,
	        configurable: true
	    });
	    PdsAbstractInputWidget.prototype.validateWidget = function (showError) {
	        if (showError === void 0) { showError = false; }
	        var validationResult = this.pds.validationEngine.validate(this.value, this.validators);
	        this.isValid = validationResult.isValid;
	        if (validationResult.isValid) {
	            this.setError('');
	            this.invalidRule = '';
	            this.setUpBadge();
	            return true;
	        }
	        else {
	            this.invalidRule = validationResult.invalidRule;
	            this.setUpBadge();
	            if (validationResult.invalidRule === 'isRequired') {
	                this.setError('');
	            }
	            else {
	                this.setError(validationResult.errorMessage);
	            }
	            if (showError) {
	                this.canShowError = true;
	            }
	            return false;
	        }
	    };
	    PdsAbstractInputWidget.prototype.setError = function (errorMsg) {
	        if (errorMsg != null && errorMsg.trim() !== '') {
	            this.errorMessage = errorMsg;
	        }
	        else {
	            this.errorMessage = '';
	        }
	    };
	    PdsAbstractInputWidget.prototype.attached = function () {
	        var valueAttr = this.getAttribute('value');
	        if (valueAttr != null) {
	            this.removeAttribute('value');
	            this.value = valueAttr;
	        }
	        this.isAttached = true;
	        this.setUpBadge();
	    };
	    PdsAbstractInputWidget.prototype.setReadonlyText = function () {
	        if (this.dataIsreadonly != null && this.value != null) {
	            var readOnlyEle = this.querySelector('.pds-readonly-data');
	            if (readOnlyEle == null) {
	                return;
	            }
	            if (this.dataIsreadonly === 'true') {
	                readOnlyEle.innerText = this.value;
	            }
	            else {
	                readOnlyEle.innerText = '';
	            }
	        }
	    };
	    PdsAbstractInputWidget.prototype.setUpBadge = function () {
	        if (this.isAttached) {
	            var isElevated = !this.isValid && this.dataDisableInvalidBadgeElevation !== 'true'
	                && this.invalidRule === 'isRequired' && this.dataIsrequired === 'true';
	            var isBadgeTextConfigured = (this.hasAttribute('data-badge-text')
	                && this.dataBadgeText != null && this.dataBadgeText.length > 0);
	            var hidingUnelevated = this.dataHideUnelevatedBadge === 'true' && !isElevated;
	            var isRequired = this.dataIsrequired === 'true';
	            this.isBadgeElevated = isElevated;
	            if (this.dataBadgeText != null && this.dataBadgeText != null
	                && this.dataBadgeText.length > 0 && this.originalBadgeText === '') {
	                this.originalBadgeText = this.dataBadgeText;
	            }
	            if (this.dataIsrequired === 'true') {
	                this.dataBadgeText = this.pds.i18n.getText(this.pds.i18n.widgetKeys['textWidget.required']);
	            }
	            else if (!isBadgeTextConfigured) {
	                this.originalBadgeText = '';
	            }
	            else if (isBadgeTextConfigured) {
	                this.dataBadgeText = this.originalBadgeText;
	            }
	            if (!hidingUnelevated && (isRequired || isBadgeTextConfigured)) {
	                this.isBadgeHidden = false;
	            }
	            else {
	                this.isBadgeHidden = true;
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
	    PdsAbstractInputWidget.prototype.hideError = function (canShowError, isValid, errorMessage) {
	        if (canShowError && !isValid && errorMessage != null && errorMessage.length > 0) {
	            return '';
	        }
	        else {
	            return 'pds-is-hidden';
	        }
	    };
	    return PdsAbstractInputWidget;
	}(PdsWidget_1.PdsWidget));
	exports.PdsAbstractInputWidget = PdsAbstractInputWidget;
	


/***/ }),
/* 3 */
/***/ (function(module, exports) {

	"use strict";
	var PdsWidget = (function () {
	    function PdsWidget() {
	    }
	    PdsWidget.prototype.ready = function () {
	        this.addMessageKeyUpdatedClass();
	    };
	    PdsWidget.prototype.addMessageKeyUpdatedClass = function () {
	        if (!this.pds.i18n.isUpdatedMessageKeys) {
	            this.classList.add('pds-default-messages');
	        }
	    };
	    PdsWidget.prototype.removeMessgeKeyUpdatedClass = function () {
	        if (this.pds.i18n.isUpdatedMessageKeys) {
	            this.classList.remove('pds-default-messages');
	        }
	    };
	    PdsWidget.prototype.querySelector = function (param) {
	        console.error('this should never have been called');
	    };
	    PdsWidget.prototype.dispatchEvent = function (e) {
	        console.error('this should never have been called');
	    };
	    PdsWidget.prototype.hasAttribute = function (name) {
	        console.error('this should never have been called');
	        return false;
	    };
	    PdsWidget.prototype.logicalAnd = function () {
	        var value = [];
	        for (var _i = 0; _i < arguments.length; _i++) {
	            value[_i - 0] = arguments[_i];
	        }
	        var answer = true === value.reduce(function (v1, v2) {
	            return v1 && v2;
	        });
	        return answer;
	    };
	    PdsWidget.prototype.conditionalClass = function (className, value1, operator, value2) {
	        if (operator == null) {
	            if (value1) {
	                return className;
	            }
	        }
	        else if (this.compare(value1, operator, value2)) {
	            return className;
	        }
	    };
	    PdsWidget.prototype.compare = function (value1, operator, value2) {
	        switch (operator.trim()) {
	            case 'is-blank':
	                return value1 == null || value1.length === 0;
	            case '== null':
	            case '==null':
	                return value1 == null;
	            case '!= null':
	            case '!=null':
	                return value1 != null;
	            case '==':
	                return value1 == value2;
	            case '!=':
	                return value1 != value2;
	            case '===':
	                return value1 === value2;
	            case '!==':
	                return value1 !== value2;
	            case '<':
	                return value1 < value2;
	            case '<=':
	                return value1 <= value2;
	            case '>':
	                return value1 > value2;
	            case '>=':
	                return value1 >= value2;
	            default:
	                throw 'operator not found';
	        }
	    };
	    return PdsWidget;
	}());
	exports.PdsWidget = PdsWidget;
	


/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var pdsUtils_1 = __webpack_require__(5);
	var PdsDateWidgetDialog = (function (_super) {
	    __extends(PdsDateWidgetDialog, _super);
	    function PdsDateWidgetDialog() {
	        _super.apply(this, arguments);
	        this.is = 'pds-date-picker-dialog';
	        this.holdRefresh = false;
	        this.properties = {
	            name: {
	                type: String,
	                value: 'pds-date-picker-dialog'
	            },
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
	        this.name = pdsUtils_1.pdsUtils.getUniqueId(this.name);
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
	


/***/ }),
/* 5 */
/***/ (function(module, exports) {

	"use strict";
	exports.pdsUtils = {
	    pds: undefined,
	    ESCAPE_USER_INPUT_REGEX: /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g,
	    ESCAPE_EXCLUDE_CHARS_REGEX: /[\-\^\*\\\]]/g,
	    TIME_STRING_AM_PM_SPACING_REGEX: /(\d)(pm|am)/i,
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
	    insertBefore: function (newNode, referenceNode) {
	        referenceNode.parentNode.insertBefore(newNode, referenceNode);
	    },
	    insertAfter: function (newNode, referenceNode) {
	        referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling);
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
	                        isFilled: true,
	                        dashCaseDate: alterDate.toISOString().split('T')[0]
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
	                isWeekend: sizeModSeven === 0 || sizeModSeven === 6,
	                dashCaseDate: dateItr.toISOString().split('T')[0]
	            });
	            dateItr.setDate(dateItr.getDate() + 1);
	        } while (dateItr.getMonth() === month);
	        if (dateTimes.length % 7 > 0) {
	            addBlanks(7 - (dateTimes.length % 7), fillBlankDays, false);
	        }
	        return dateTimes;
	    },
	    getpageYOffsetLimit: function () {
	        return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight) - window.innerHeight;
	    },
	    getUniqueId: function (theId) {
	        var curNumber = 1;
	        var curId = theId + "_" + curNumber;
	        if (document.getElementById(theId) == null) {
	            return theId;
	        }
	        while (document.getElementById(curId) != null) {
	            curNumber += 1;
	            curId = theId + "_" + curNumber;
	        }
	        return curId;
	    },
	    sort: function (array, valueExtractor) {
	        if (array == null || array.length === 0) {
	            return;
	        }
	        array.sort(function (a, b) {
	            var varA = valueExtractor(a);
	            var varB = valueExtractor(b);
	            if (varA < varB) {
	                return -1;
	            }
	            else if (varA > varB) {
	                return 1;
	            }
	            else {
	                return 0;
	            }
	        });
	    },
	    TOKEN_REGEX: /{[^}]+}/g,
	    replaceTokensInString: function (theString, context) {
	        if (theString == null || context == null || theString === '') {
	            return theString;
	        }
	        if (typeof context === 'string') {
	            var allTokens_1 = theString.match(this.TOKEN_REGEX);
	            if (allTokens_1 == null) {
	                return theString;
	            }
	            var valid = allTokens_1.every(function (_token) {
	                return _token === allTokens_1[0];
	            });
	            if (!valid) {
	                throw 'replaceTokensInString called with invalid parameters.';
	            }
	            return theString.replace(this.TOKEN_REGEX, context);
	        }
	        for (var key in context) {
	            if (context.hasOwnProperty(key)) {
	                var re = new RegExp("{" + key + "}", 'ig');
	                theString = theString.replace(re, context[key]);
	            }
	        }
	        return theString;
	    },
	    getUrlSearchParams: function () {
	        var params = {};
	        var search = window.location.search;
	        if (search != null && search.length > 1) {
	            var parts = void 0;
	            search = search.substring(1);
	            for (var _i = 0, _a = search.split('&'); _i < _a.length; _i++) {
	                var token = _a[_i];
	                parts = token.split('=');
	                if (parts != null && parts.length > 0) {
	                    params[parts[0]] = parts[1];
	                }
	            }
	        }
	        return params;
	    },
	    parseUrlSearchObjectParam: function (param, paramEncoded) {
	        if (paramEncoded === void 0) { paramEncoded = true; }
	        var paramString = unescape(param);
	        if (paramEncoded) {
	            paramString = atob(paramString);
	        }
	        var parsedParam = JSON.parse(paramString);
	        return parsedParam;
	    },
	    stringifyUrlSearchObjectParam: function (param, encodeParam) {
	        if (encodeParam === void 0) { encodeParam = true; }
	        var p = JSON.stringify(param);
	        if (encodeParam) {
	            p = btoa(p);
	        }
	        return p;
	    },
	    removeContextMarkerFromUrl: function (url) {
	        var ucCtx = 'ucCtx=\{unifiedClassroomContext\}';
	        return url.replace(new RegExp('&' + ucCtx), '')
	            .replace(new RegExp('\\?' + ucCtx + '&'), '?')
	            .replace(new RegExp('\\?' + ucCtx), '');
	    },
	    getSectionColorForClass: function (sectionOrGroup) {
	        var colorNumber = 1;
	        if (sectionOrGroup == null) {
	            return 'color-' + colorNumber;
	        }
	        if (sectionOrGroup && sectionOrGroup.sourceSystemId != null && sectionOrGroup.courseNumber != null) {
	            if (isNaN(parseInt(sectionOrGroup.courseNumber))) {
	                colorNumber = (Number(sectionOrGroup.sourceSystemId) % 4) + 1;
	            }
	            else {
	                colorNumber = (parseInt(sectionOrGroup.courseNumber) % 4) + 1;
	            }
	        }
	        else if (sectionOrGroup && sectionOrGroup.sectionUids != null) {
	            colorNumber = (sectionOrGroup.sectionUids.length % 4) + 1;
	        }
	        return 'color-' + colorNumber;
	    },
	    fixTimeStringSpacing: function (timeString) {
	        if (timeString != null) {
	            return timeString.replace(this.TIME_STRING_AM_PM_SPACING_REGEX, '$1 $2');
	        }
	        else {
	            return timeString;
	        }
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
	if (!Date.prototype.pdsToDateWidgetAttr) {
	    Date.prototype.pdsToDateWidgetAttr = function () {
	        return (this.getMonth() + 1) + '/' + this.getDate() + '/' + this.getFullYear();
	    };
	}
	


/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var PdsAppNav = (function (_super) {
	    __extends(PdsAppNav, _super);
	    function PdsAppNav() {
	        _super.apply(this, arguments);
	        this.is = 'pds-app-nav';
	        this.navigation = [];
	        this.navOpen = false;
	        this.userMenuOpen = false;
	        this.navCollapsed = false;
	        this.secondaryOpen = 'closed';
	    }
	    PdsAppNav.prototype.attached = function () {
	        var _this = this;
	        this.navCollapsed = false;
	        if (!this.hasOwnProperty('appName')) {
	            this.appName = 'PowerSchool';
	        }
	        setTimeout(function () {
	            _this.setHighlights();
	        });
	    };
	    PdsAppNav.prototype.logoClickHandler = function (event) {
	        var _this = this;
	        event.preventDefault();
	        this.closeSecondary(event);
	        if (this.homeNavItem != null && this.homeNavItem.onUserClick != null) {
	            this.homeNavItem.onUserClick(this.homeNavItem, event);
	            setTimeout(function () {
	                _this.setHighlights();
	            });
	        }
	    };
	    PdsAppNav.prototype.primaryClickHandler = function (event) {
	        event.preventDefault();
	        var target = event.target;
	        if (!this.pds.utils.is(event.target, 'a')) {
	            target = this.pds.utils.getClosest(target, 'a');
	        }
	        var nav = target.dataNav;
	        this.selectedNav = nav;
	        if (nav.children != null && nav.children.length > 0) {
	            this.setSecondaryOpenState('hard');
	        }
	        else {
	            this.closeNav();
	            this.setSecondaryOpenState('closed');
	            if (nav.onUserClick != null) {
	                nav.onUserClick(nav, event);
	            }
	            else {
	                throw 'NavItems that do not have children must have the onUserClick function';
	            }
	        }
	    };
	    PdsAppNav.prototype.secondaryClickHandler = function (event) {
	        event.preventDefault();
	        var target = event.target;
	        if (!this.pds.utils.is(target, 'a')) {
	            target = this.pds.utils.getClosest(target, 'a');
	        }
	        var nav = target.dataNav;
	        var parent = target.dataParent;
	        this.selectedSecondaryNav = nav;
	        if (nav.onUserClick != null) {
	            nav.onUserClick(nav, event);
	        }
	        else {
	            throw "NavItem " + nav.id + " did not have onUserClick function defined.";
	        }
	        this.setSecondaryOpenState(this.navCollapsed ? 'closed' : 'soft');
	        this.closeNav();
	    };
	    PdsAppNav.prototype.userMenuClickHandler = function (event) {
	        event.preventDefault();
	        var target = event.target;
	        if (!this.pds.utils.is(target, 'a')) {
	            target = this.pds.utils.getClosest(target, 'a');
	        }
	        var nav = target.dataNav;
	        this.toggleUserMenu();
	        this.closeNav();
	        if (nav.onUserClick != null) {
	            nav.onUserClick(nav, event);
	        }
	        else {
	            throw "NavItem " + nav.id + " did not have onUserClick function defined.";
	        }
	        this.setSecondaryOpenState('closed');
	    };
	    PdsAppNav.prototype.closeSecondary = function (event) {
	        event.preventDefault();
	        this.setSecondaryOpenState('closed');
	        this.setHighlights('closed');
	    };
	    PdsAppNav.prototype.toggleNav = function (event) {
	        event.preventDefault();
	        this.navOpen = !this.navOpen;
	    };
	    PdsAppNav.prototype.closeNav = function () {
	        this.navOpen = false;
	    };
	    PdsAppNav.prototype.toggleUserMenu = function (event) {
	        if (event != null) {
	            event.preventDefault();
	        }
	        this.userMenuOpen = !this.userMenuOpen;
	    };
	    PdsAppNav.prototype.toggleNavCollapsed = function (event) {
	        event.preventDefault();
	        this.navCollapsed = !this.navCollapsed;
	        if (this.navCollapsed) {
	            this.classList.add('pds-is-collapsed');
	            this.setSecondaryOpenState('closed');
	        }
	        else {
	            this.classList.remove('pds-is-collapsed');
	        }
	        this.fire('pdsToggleNav', { navCollapsed: this.navCollapsed });
	    };
	    PdsAppNav.prototype.messageKeysUpdated = function () { };
	    PdsAppNav.prototype.setSecondaryOpenState = function (secondaryOpen) {
	        this.secondaryOpen = secondaryOpen;
	    };
	    PdsAppNav.prototype.setHighlights = function (secondaryState) {
	        var _this = this;
	        if (secondaryState === void 0) { secondaryState = 'soft'; }
	        this.selectedNav = null;
	        this.selectedSecondaryNav = null;
	        this.navigation.find(function (navItem) {
	            if (navItem.children != null && navItem.children.length > 0) {
	                return null != navItem.children.find(function (childItem) {
	                    if (childItem.isCurrentRoute != null && childItem.isCurrentRoute(childItem)) {
	                        _this.selectedSecondaryNav = childItem;
	                        _this.selectedNav = navItem;
	                        _this.setSecondaryOpenState(secondaryState);
	                        return true;
	                    }
	                    return false;
	                });
	            }
	            if (navItem.isCurrentRoute != null && navItem.isCurrentRoute(navItem)) {
	                _this.selectedNav = navItem;
	                return true;
	            }
	            return false;
	        });
	    };
	    PdsAppNav.prototype.isSecondaryOverlay = function () {
	        var windowWidth = window.innerWidth;
	        return !((windowWidth > 1024 && !this.navCollapsed) || windowWidth <= 768);
	    };
	    return PdsAppNav;
	}(PdsWidget_1.PdsWidget));
	exports.PdsAppNav = PdsAppNav;
	


/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var pdsUtils_1 = __webpack_require__(5);
	var PdsClassBlock = (function (_super) {
	    __extends(PdsClassBlock, _super);
	    function PdsClassBlock() {
	        _super.apply(this, arguments);
	        this.is = 'pds-class-block';
	        this.showLinks = false;
	    }
	    PdsClassBlock.prototype.attached = function () {
	        var _this = this;
	        var classPickerElement = document.querySelector('pds-class-picker');
	        classPickerElement.addEventListener('pdsCloseOptions', function (event) {
	            if (_this !== event.srcElement) {
	                _this.showLinks = false;
	            }
	        });
	        classPickerElement.addEventListener('click', function (event) {
	            _this.showLinks = false;
	        });
	    };
	    PdsClassBlock.prototype.messageKeysUpdated = function () { };
	    PdsClassBlock.prototype.classChange = function (event) {
	        event.preventDefault();
	        event.stopPropagation();
	        var target = event.target;
	        if (!this.pds.utils.is(target, 'a')) {
	            target = this.pds.utils.getClosest(target, 'a');
	        }
	        var newClass = target.dataSection;
	        this.fire('pdsClassChange', newClass);
	    };
	    PdsClassBlock.prototype.clickOptions = function (event) {
	        event.preventDefault();
	        event.stopPropagation();
	        this.showLinks = !this.showLinks;
	        if (this.showLinks) {
	            this.fire('pdsCloseOptions', null);
	        }
	    };
	    PdsClassBlock.prototype.clickOptionsLink = function (event) {
	        event.preventDefault();
	        event.stopPropagation();
	        var target = event.target;
	        if (!this.pds.utils.is(event.target, 'a')) {
	            target = this.pds.utils.getClosest(target, 'a');
	        }
	        var link = target.dataLink;
	        var newClass = target.dataSection;
	        link.section = newClass;
	        if (link.linkClicked != null) {
	            link.linkClicked(link, event);
	        }
	        else {
	            throw 'No onUserClick function found';
	        }
	        this.fire('pdsCloseClassPicker', null);
	        this.showLinks = false;
	    };
	    PdsClassBlock.prototype.getAttendanceStatusIconName = function (status) {
	        if (status == null) {
	            return '';
	        }
	        switch (status.toUpperCase()) {
	            case 'NA':
	                return 'attendance-f';
	            case 'GREEN':
	                return 'checkmark-circle-f';
	            case 'YELLOW':
	                return 'attendance-f';
	            case 'RED':
	                return 'attendance-f';
	            default:
	                return '';
	        }
	    };
	    PdsClassBlock.prototype.getSectionColorClass = function (sectionOrGroup) {
	        return pdsUtils_1.pdsUtils.getSectionColorForClass(sectionOrGroup);
	    };
	    PdsClassBlock.prototype.getLinkId = function (sectionOrGroup) {
	        if (sectionOrGroup == null) {
	            return 'no-section-error';
	        }
	        if (sectionOrGroup.uid != null) {
	            return sectionOrGroup.uid;
	        }
	        else if (sectionOrGroup.groupName != null) {
	            return sectionOrGroup.groupName.replace(/\s+/g, '-');
	        }
	        else {
	            throw 'ClassPickerClass needs to either have a group name or a uid.';
	        }
	    };
	    return PdsClassBlock;
	}(PdsWidget_1.PdsWidget));
	exports.PdsClassBlock = PdsClassBlock;
	


/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var pdsUtils_1 = __webpack_require__(5);
	var PdsClassPicker = (function (_super) {
	    __extends(PdsClassPicker, _super);
	    function PdsClassPicker() {
	        _super.apply(this, arguments);
	        this.is = 'pds-class-picker';
	    }
	    PdsClassPicker.prototype.ready = function () {
	        this.showClasses = true;
	        this.isClassOnly = false;
	        this.possibleSchedulingTerms = [];
	        this.possibleYears = [];
	        this.studentMap = new Map();
	        this.selectedStudent = '';
	        this.addEventListener('pdsClassChange', this.classChangeEvent);
	        this.addEventListener('pdsCloseClassPicker', this.closeClassSelector);
	    };
	    PdsClassPicker.prototype.messageKeysUpdated = function () { };
	    PdsClassPicker.prototype.toggleClassSelector = function (event) {
	        event.preventDefault();
	        this.showClassSelector = !this.showClassSelector;
	        if (this.showClassSelector) {
	            this.fire('pdsClassPickerOpen', true);
	        }
	    };
	    PdsClassPicker.prototype.closeClassSelector = function () {
	        this.showClassSelector = false;
	    };
	    PdsClassPicker.prototype.selectClasses = function (event) {
	        event.preventDefault();
	        this.showClasses = true;
	        this.showGroups = false;
	    };
	    PdsClassPicker.prototype.selectGroups = function (event) {
	        event.preventDefault();
	        this.showClasses = false;
	        this.showGroups = true;
	    };
	    PdsClassPicker.prototype.selectedClassDisplay = function (selectedClass) {
	        if (selectedClass == null) {
	            return 'No Class Selected';
	        }
	        if (selectedClass.schedulingTerm != null) {
	            return selectedClass.periodDay + " " + selectedClass.courseName;
	        }
	        else {
	            if (selectedClass.sectionUids != null) {
	                return selectedClass.groupName + " - " + selectedClass.sectionUids.length + " Classes";
	            }
	            else {
	                return "" + selectedClass.groupName;
	            }
	        }
	    };
	    PdsClassPicker.prototype.classChangeEvent = function (event) {
	        var newClass = event.detail;
	        this.selectedClass = newClass;
	        this.showClassSelector = false;
	    };
	    PdsClassPicker.prototype.yearChangeEvent = function (event) {
	        this.fire('pdsYearChange', this.selectedYear);
	    };
	    PdsClassPicker.prototype.schedulingTermChangeEvent = function (event) {
	        this.fire('pdsSchedulingTermChange', this.selectedSchedulingTerm);
	    };
	    PdsClassPicker.prototype.studentChangeEvent = function (event) {
	        this.fire('pdsStudentChange', this.selectedStudent);
	    };
	    PdsClassPicker.prototype.classScheduleEmptyCheck = function (classSchedule) {
	        return classSchedule == null || classSchedule.sections == null || classSchedule.sections.length === 0;
	    };
	    PdsClassPicker.prototype.classGroupingCheck = function (classGrouping) {
	        return classGrouping != null && classGrouping.length > 0;
	    };
	    PdsClassPicker.prototype.getPossibleYears = function (years) {
	        this.possibleYears.length = 0;
	        for (var _i = 0, years_1 = years; _i < years_1.length; _i++) {
	            var year = years_1[_i];
	            this.possibleYears.push({
	                text: year,
	                value: year
	            });
	        }
	        return this.possibleYears;
	    };
	    PdsClassPicker.prototype.getPossibleSchedulingTerms = function (schedulingTerms) {
	        this.possibleSchedulingTerms.length = 0;
	        for (var _i = 0, schedulingTerms_1 = schedulingTerms; _i < schedulingTerms_1.length; _i++) {
	            var term = schedulingTerms_1[_i];
	            this.possibleSchedulingTerms.push({
	                text: term,
	                value: term
	            });
	        }
	        return this.possibleSchedulingTerms;
	    };
	    PdsClassPicker.prototype.getStudentOptions = function (studentOptions) {
	        var options = [];
	        for (var _i = 0, studentOptions_1 = studentOptions; _i < studentOptions_1.length; _i++) {
	            var student = studentOptions_1[_i];
	            this.studentMap.set(student.uid, student);
	            options.push({
	                value: student.uid,
	                text: student.firstName + " " + student.lastName
	            });
	        }
	        if (this.selectedStudent == null || this.selectedStudent.length === 0) {
	            this.selectedStudent = studentOptions[0].uid;
	        }
	        return options;
	    };
	    PdsClassPicker.prototype.getSectionColorClass = function (sectionOrGroup) {
	        return pdsUtils_1.pdsUtils.getSectionColorForClass(sectionOrGroup);
	    };
	    PdsClassPicker.prototype.hasAllSectionsGroup = function (classSchedule, isClassOnly) {
	        return isClassOnly && classSchedule.allClasses != null;
	    };
	    PdsClassPicker.prototype.getInfoMessage = function (selectedStudent) {
	        if (this.studentOptions != null && this.studentOptions.length > 0) {
	            var student = this.studentMap.get(selectedStudent);
	            return (student != null ? student.firstName : 'The selected student ') + " has no classes scheduled during the current term.";
	        }
	        else {
	            return 'There are no classes in your schedule during the selected year.';
	        }
	    };
	    return PdsClassPicker;
	}(PdsWidget_1.PdsWidget));
	exports.PdsClassPicker = PdsClassPicker;
	


/***/ }),
/* 9 */
/***/ (function(module, exports) {

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
	


/***/ }),
/* 10 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var pds_abstract_input_widget_1 = __webpack_require__(2);
	var PdsTextWidget = (function (_super) {
	    __extends(PdsTextWidget, _super);
	    function PdsTextWidget() {
	        _super.apply(this, arguments);
	        this.is = 'pds-text-widget';
	        this.properties = {
	            name: String,
	            dataLabelText: String,
	            dataBadgeText: {
	                type: String,
	                value: '',
	                observer: 'setUpBadge'
	            },
	            dataHelperText: {
	                type: String,
	                value: null
	            },
	            dataFieldHelpText: String,
	            dataPlaceholderText: String,
	            dataTooltipText: String,
	            dataIsreadonly: {
	                type: String,
	                value: 'false',
	                observer: 'setReadonlyText'
	            },
	            dataIsfieldonly: {
	                type: String,
	                value: 'false'
	            },
	            dataHideUnelevatedBadge: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataDisableInvalidBadgeElevation: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataRegexErrorText: String,
	            dataInputType: {
	                type: String,
	                value: 'text'
	            },
	            dataIsrequired: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataMinlength: String,
	            dataMaxlength: String,
	            dataExcludechars: String,
	            dataRegex: String,
	            dataRegexmodifiers: String,
	            dataCustomvalidate: String,
	            dataAdditionalInputAttributes: Object,
	            dataAdditionalErrorAttributes: Object
	        };
	    }
	    PdsTextWidget.prototype.generateValidationRules = function () {
	        var validationRules = this.pds.validationEngine.getBasicValidationRules();
	        validationRules.isText = true;
	        validationRules.setProperty('isRequired', this.dataIsrequired, Boolean);
	        validationRules.setProperty('maxLength', this.dataMaxlength, Number);
	        validationRules.setProperty('minLength', this.dataMinlength, Number);
	        validationRules.setProperty('excludeChars', this.dataExcludechars, String);
	        if (this.dataRegex != null && this.dataRegex.length > 0 &&
	            this.dataRegexErrorText != null && this.dataRegexErrorText.length > 0) {
	            validationRules.regex = {
	                pattern: this.dataRegex != null ? new RegExp(this.dataRegex, this.dataRegexmodifiers) : new RegExp(this.dataRegex),
	                errorMessage: this.dataRegexErrorText
	            };
	        }
	        this.validators = this.pds.validationEngine.getValidatorsForRules(validationRules);
	        if ('dataCustomvalidate' in this) {
	            this.validators.push({
	                execute: this.pds.validation.getCustomValidate(this.dataCustomvalidate)
	            });
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
	    PdsTextWidget.prototype.messageKeysUpdated = function () {
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
	    return PdsTextWidget;
	}(pds_abstract_input_widget_1.PdsAbstractInputWidget));
	exports.PdsTextWidget = PdsTextWidget;
	


/***/ }),
/* 11 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var pds_abstract_input_widget_1 = __webpack_require__(2);
	var isIntegerRegex = /^([-]?[0-9]*)?$/;
	var PdsNumberWidget = (function (_super) {
	    __extends(PdsNumberWidget, _super);
	    function PdsNumberWidget() {
	        _super.apply(this, arguments);
	        this.is = 'pds-number-widget';
	        this.properties = {
	            name: String,
	            dataLabelText: String,
	            dataBadgeText: {
	                type: String,
	                value: '',
	                observer: 'setUpBadge'
	            },
	            dataHelperText: {
	                type: String,
	                value: null
	            },
	            dataFieldHelpText: String,
	            dataPlaceholderText: String,
	            dataTooltipText: String,
	            dataRegexErrorText: String,
	            dataIsreadonly: {
	                type: String,
	                value: 'false',
	                observer: 'setReadonlyText'
	            },
	            dataIsfieldonly: {
	                type: String,
	                value: 'false'
	            },
	            dataHideUnelevatedBadge: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataDisableInvalidBadgeElevation: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataIsrequired: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataIsinteger: String,
	            dataMinlength: String,
	            dataMaxlength: String,
	            dataMaxvalue: String,
	            dataMinvalue: String,
	            dataMaxdecimals: String,
	            dataMinvalue_exclusive: String,
	            dataMaxvalue_exclusive: String,
	            dataCustomvalidate: String
	        };
	    }
	    PdsNumberWidget.prototype.generateValidationRules = function () {
	        var validationRules = this.pds.validationEngine.getBasicValidationRules();
	        validationRules.isNumber = true;
	        validationRules.setProperty('isRequired', this.dataIsrequired, Boolean);
	        validationRules.setProperty('isInteger', this.dataIsinteger, Boolean);
	        validationRules.setProperty('minLength', this.dataMinlength, Number);
	        validationRules.setProperty('maxLength', this.dataMaxlength, Number);
	        validationRules.setProperty('minValue', this.dataMinvalue, Number);
	        validationRules.setProperty('maxValue', this.dataMaxvalue, Number);
	        validationRules.setProperty('minValueExclusive', this.dataMinvalue_exclusive, Number);
	        validationRules.setProperty('maxValueExclusive', this.dataMaxvalue_exclusive, Number);
	        validationRules.setProperty('maxDecimals', this.dataMaxdecimals, Number);
	        this.validators = this.pds.validationEngine.getValidatorsForRules(validationRules);
	        if (this.hasOwnProperty('dataCustomvalidate')) {
	            this.validators.push({
	                execute: this.pds.validation.getCustomValidate(this.dataCustomvalidate)
	            });
	        }
	    };
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
	    return PdsNumberWidget;
	}(pds_abstract_input_widget_1.PdsAbstractInputWidget));
	exports.PdsNumberWidget = PdsNumberWidget;
	


/***/ }),
/* 12 */
/***/ (function(module, exports) {

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
	


/***/ }),
/* 13 */
/***/ (function(module, exports) {

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
	    timeRegexString: '^(0?[1-9]|10|11|12) *: *([0-5]\\d) *(am|pm)$',
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
	    makeStrFromTime: function (time, padWithZero) {
	        if (padWithZero === void 0) { padWithZero = true; }
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
	        if (padWithZero && hours < 10) {
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
	        return hoursString + separator + minsString + (show24Hours ? '' : ' ' + ampmNames[time.getHours() < 12 ? 0 : 1]);
	    }
	};
	


/***/ }),
/* 14 */
/***/ (function(module, exports) {

	"use strict";
	exports.pdsValidation = {
	    pds: undefined,
	    _customValidationFunctions: {},
	    validateElements: function (element) {
	        if (element == null) {
	            return true;
	        }
	        var allElementsAreValid = true;
	        var inputWidgets = element.querySelectorAll('pds-number-widget,pds-date-widget,pds-text-widget');
	        for (var i = 0; i < inputWidgets.length; i++) {
	            allElementsAreValid = inputWidgets[i].validateWidget(true) && allElementsAreValid;
	        }
	        return allElementsAreValid;
	    },
	    registerCustomValidate: function (functionName, executeFunction) {
	        if (functionName == null || functionName === '' || executeFunction == null) {
	            return;
	        }
	        this._customValidationFunctions[functionName] = executeFunction;
	    },
	    getCustomValidate: function (functionName) {
	        return this._customValidationFunctions[functionName];
	    }
	};
	


/***/ }),
/* 15 */
/***/ (function(module, exports, __webpack_require__) {

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
	


/***/ }),
/* 16 */
/***/ (function(module, exports, __webpack_require__) {

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
	


/***/ }),
/* 17 */
/***/ (function(module, exports) {

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
	


/***/ }),
/* 18 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var number_validation_rules_1 = __webpack_require__(19);
	var date_validation_rules_1 = __webpack_require__(20);
	var text_validation_rules_1 = __webpack_require__(21);
	var validResult = {
	    isValid: true
	};
	var setProperty = function (property, value, type) {
	    if (type === void 0) { type = String; }
	    var parsedValue;
	    if (value == null || value === '') {
	        return;
	    }
	    if (type === Boolean) {
	        parsedValue = value === 'true';
	    }
	    else {
	        parsedValue = new type(value);
	    }
	    if (typeof parsedValue === 'number' && isNaN(parsedValue)) {
	        return;
	    }
	    if (parsedValue instanceof Date && isNaN(parsedValue.getTime())) {
	        return;
	    }
	    this[property] = parsedValue;
	};
	exports.pdsValidationRulesEngine = {
	    _validateIsRequired: function _validateIsRequired(input, condition, context) {
	        if (input == null || input.trim().length === 0) {
	            return {
	                isValid: false,
	                errorMessage: 'required',
	                invalidRule: 'isRequired'
	            };
	        }
	        else {
	            return validResult;
	        }
	    },
	    _getNumberValidators: function (rules) {
	        var validators = [];
	        if (rules.isRequired) {
	            validators.push({
	                execute: this._validateIsRequired
	            });
	        }
	        validators.push({
	            execute: number_validation_rules_1.numberValidationRules.validateIsNumber
	        });
	        if (rules.isInteger) {
	            validators.push({
	                execute: number_validation_rules_1.numberValidationRules.validateIsInteger
	            });
	        }
	        if (rules.maxValue != null && typeof rules.maxValue !== 'string') {
	            validators.push({
	                execute: number_validation_rules_1.numberValidationRules.validateMaxNumberValue,
	                condition: rules.maxValue
	            });
	        }
	        if (rules.minValue != null && typeof rules.minValue !== 'string') {
	            validators.push({
	                execute: number_validation_rules_1.numberValidationRules.validateMinNumberValue,
	                condition: rules.minValue
	            });
	        }
	        if (rules.maxValueExclusive != null && typeof rules.maxValueExclusive !== 'string') {
	            validators.push({
	                execute: number_validation_rules_1.numberValidationRules.validateMaxNumberValueExclusive,
	                condition: rules.maxValueExclusive
	            });
	        }
	        if (rules.minValueExclusive != null && typeof rules.minValueExclusive !== 'string') {
	            validators.push({
	                execute: number_validation_rules_1.numberValidationRules.validateMinNumberValueExclusive,
	                condition: rules.minValueExclusive
	            });
	        }
	        if (rules.maxLength != null) {
	            validators.push({
	                execute: number_validation_rules_1.numberValidationRules.validateMaxNumberLength,
	                condition: rules.maxLength
	            });
	        }
	        if (rules.minLength != null) {
	            validators.push({
	                execute: number_validation_rules_1.numberValidationRules.validateMinNumberLength,
	                condition: rules.minLength
	            });
	        }
	        if (rules.maxDecimals != null) {
	            validators.push({
	                execute: number_validation_rules_1.numberValidationRules.validateMaxDecimals,
	                condition: rules.maxDecimals
	            });
	        }
	        return validators;
	    },
	    _getDateValidators: function (rules) {
	        var validators = [];
	        if (rules.isRequired) {
	            validators.push({
	                execute: this._validateIsRequired
	            });
	        }
	        validators.push({
	            execute: date_validation_rules_1.dateValidationRules.validateIsDate
	        });
	        if (rules.maxValue instanceof Date) {
	            validators.push({
	                execute: date_validation_rules_1.dateValidationRules.validateMaxDate,
	                condition: rules.maxValue
	            });
	        }
	        if (rules.minValue instanceof Date) {
	            validators.push({
	                execute: date_validation_rules_1.dateValidationRules.validateMinDate,
	                condition: rules.minValue
	            });
	        }
	        return validators;
	    },
	    _getTextValidators: function (rules) {
	        var validators = [];
	        if (rules.isRequired) {
	            validators.push({
	                execute: this._validateIsRequired
	            });
	        }
	        if (rules.maxLength != null) {
	            validators.push({
	                execute: text_validation_rules_1.textValidationRules.validateMaxTextLength,
	                condition: rules.maxLength
	            });
	        }
	        if (rules.minLength != null) {
	            validators.push({
	                execute: text_validation_rules_1.textValidationRules.validateMinTextLength,
	                condition: rules.minLength
	            });
	        }
	        if (rules.excludeChars != null) {
	            var escapedChars = rules.excludeChars.replace(this.pds.utils.ESCAPE_EXCLUDE_CHARS_REGEX, '\\$&');
	            validators.push({
	                execute: text_validation_rules_1.textValidationRules.validateExcludeChars,
	                condition: {
	                    pattern: new RegExp("[" + escapedChars + "]", 'i'),
	                    excludeChars: rules.excludeChars
	                }
	            });
	        }
	        if (rules.regex != null) {
	            validators.push({
	                execute: text_validation_rules_1.textValidationRules.validateRegex,
	                condition: rules.regex
	            });
	        }
	        return validators;
	    },
	    getValidatorsForRules: function (rules) {
	        var validators = [];
	        if (rules.isNumber) {
	            validators = this._getNumberValidators(rules);
	        }
	        else if (rules.isDate) {
	            validators = this._getDateValidators(rules);
	        }
	        else if (rules.isText) {
	            validators = this._getTextValidators(rules);
	        }
	        return validators;
	    },
	    validate: function (value, validators) {
	        if (validators == null || validators.length === 0) {
	            return {
	                isValid: true
	            };
	        }
	        if (validators[0].execute !== this._validateIsRequired &&
	            (value === '' || value == null)) {
	            return {
	                isValid: true
	            };
	        }
	        var context = {};
	        for (var _i = 0, validators_1 = validators; _i < validators_1.length; _i++) {
	            var validator = validators_1[_i];
	            var result = validator.execute.call(this, value, validator.condition, context);
	            if (!result.isValid) {
	                return result;
	            }
	        }
	        return {
	            isValid: true
	        };
	    },
	    validateWithRules: function (value, rules) {
	        var validators = this.getValidatorsForRules(rules);
	        return this.validate(value, validators);
	    },
	    getBasicValidationRules: function () {
	        return {
	            setProperty: setProperty
	        };
	    }
	};
	


/***/ }),
/* 19 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var pdsI18n_1 = __webpack_require__(13);
	exports.numberValidationRules = {
	    validateIsNumber: function validateIsNumber(input, condition, context) {
	        var result = {
	            isValid: pdsI18n_1.pdsI18n.isValidNumber(input)
	        };
	        if (result.isValid) {
	            context.parsedNumber = pdsI18n_1.pdsI18n.deLocalizeNumber(input);
	        }
	        else {
	            result.errorMessage = 'Must be a number';
	        }
	        return result;
	    },
	    validateIsInteger: function validateIsInteger(input, condition, context) {
	        var result = {
	            isValid: /^([-]?[0-9]*)?$/.test(input)
	        };
	        if (!result.isValid) {
	            result.errorMessage = input + " is not a valid integer.";
	        }
	        return result;
	    },
	    validateMaxNumberValue: function validateMaxNumberValue(input, maxValue, context) {
	        var result = {
	            isValid: context.parsedNumber <= maxValue
	        };
	        if (!result.isValid) {
	            result.errorMessage = "The number must be less than or equal to " + maxValue;
	        }
	        return result;
	    },
	    validateMinNumberValue: function validateMinNumberValue(input, minValue, context) {
	        var result = {
	            isValid: context.parsedNumber >= minValue
	        };
	        if (!result.isValid) {
	            result.errorMessage = "The number must be greater than or equal to " + minValue;
	        }
	        return result;
	    },
	    validateMaxNumberLength: function validateMaxNumberLength(input, maxLength, context) {
	        var result = {
	            isValid: input.length <= maxLength
	        };
	        if (!result.isValid) {
	            result.errorMessage = "The number must have " + maxLength + " or less digits.";
	        }
	        return result;
	    },
	    validateMinNumberLength: function validateMinNumberLength(input, minLength, context) {
	        var result = {
	            isValid: input.length >= minLength
	        };
	        if (!result.isValid) {
	            result.errorMessage = "The number must have " + minLength + " or more digits.";
	        }
	        return result;
	    },
	    validateMaxNumberValueExclusive: function validateMaxNumberValueExclusive(input, maxValue, context) {
	        var result = {
	            isValid: context.parsedNumber < maxValue
	        };
	        if (!result.isValid) {
	            result.errorMessage = "The number must be less than " + maxValue;
	        }
	        return result;
	    },
	    validateMinNumberValueExclusive: function validateMinNumberValueExclusive(input, minValue, context) {
	        var result = {
	            isValid: context.parsedNumber > minValue
	        };
	        if (!result.isValid) {
	            result.errorMessage = "The number must be greater than " + minValue;
	        }
	        return result;
	    },
	    validateMaxDecimals: function validateMaxDecimals(input, maxDecimals, context) {
	        var countDecimals = function (value) {
	            if ((value % 1) === 0) {
	                return 0;
	            }
	            return value.toString().split('.')[1].length;
	        };
	        var result = {
	            isValid: countDecimals(context.parsedNumber) <= maxDecimals
	        };
	        if (!result.isValid) {
	            result.errorMessage = "The number cannot have exceed " + maxDecimals + " decimal places";
	        }
	        return result;
	    }
	};
	


/***/ }),
/* 20 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var pdsI18n_1 = __webpack_require__(13);
	exports.dateValidationRules = {
	    validateIsDate: function validateIsDate(input, condition, context) {
	        var result = {
	            isValid: pdsI18n_1.pdsI18n.isValidDate(input)
	        };
	        if (result.isValid) {
	            context.parsedDate = pdsI18n_1.pdsI18n.deLocalizeDate(input);
	        }
	        else {
	            result.errorMessage = 'Must be a date';
	        }
	        return result;
	    },
	    validateMaxDate: function validateMaxDate(input, maxDate, context) {
	        var result = {
	            isValid: context.parsedDate.getTime() <= maxDate.getTime()
	        };
	        if (!result.isValid) {
	            result.errorMessage = 'The date must be on or before ' + pdsI18n_1.pdsI18n.localizeDate(maxDate);
	        }
	        return result;
	    },
	    validateMinDate: function validateMinDate(input, minDate, context) {
	        var result = {
	            isValid: context.parsedDate.getTime() >= minDate.getTime()
	        };
	        if (!result.isValid) {
	            result.errorMessage = 'The date must be on or after ' + pdsI18n_1.pdsI18n.localizeDate(minDate);
	        }
	        return result;
	    }
	};
	


/***/ }),
/* 21 */
/***/ (function(module, exports) {

	"use strict";
	exports.textValidationRules = {
	    validateMaxTextLength: function validateMaxTextLength(input, maxLength, context) {
	        var result = {
	            isValid: input.length <= maxLength
	        };
	        if (!result.isValid) {
	            result.errorMessage = "The text must have " + maxLength + " or less characters.";
	        }
	        return result;
	    },
	    validateMinTextLength: function validateMinTextLength(input, minLength, context) {
	        var result = {
	            isValid: input.length >= minLength
	        };
	        if (!result.isValid) {
	            result.errorMessage = "The text must have " + minLength + " or more characters.";
	        }
	        return result;
	    },
	    validateExcludeChars: function validateExcludeChars(input, condition, context) {
	        var result = {
	            isValid: !condition.pattern.test(input)
	        };
	        if (!result.isValid) {
	            result.errorMessage = "Must not contain any characters in " + condition.excludeChars;
	        }
	        return result;
	    },
	    validateRegex: function validateRegex(input, condition, context) {
	        var result = {
	            isValid: condition.pattern.test(input)
	        };
	        if (!result.isValid) {
	            result.errorMessage = condition.errorMessage;
	        }
	        return result;
	    }
	};
	


/***/ }),
/* 22 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var isIntegerRegex = /^([-]?[0-9]*)?$/;
	var PdsProgressBarWidget = (function (_super) {
	    __extends(PdsProgressBarWidget, _super);
	    function PdsProgressBarWidget() {
	        _super.apply(this, arguments);
	        this.is = 'pds-progress-bar-widget';
	        this.properties = {
	            width: {
	                type: Number,
	                value: 0,
	                notify: true,
	                reflectToAttribute: true
	            }
	        };
	    }
	    PdsProgressBarWidget.prototype.messageKeysUpdated = function () {
	    };
	    PdsProgressBarWidget.prototype.validateWidget = function () {
	        return true;
	    };
	    ;
	    return PdsProgressBarWidget;
	}(PdsWidget_1.PdsWidget));
	exports.PdsProgressBarWidget = PdsProgressBarWidget;
	


/***/ }),
/* 23 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var PdsReportingTermSelector = (function (_super) {
	    __extends(PdsReportingTermSelector, _super);
	    function PdsReportingTermSelector() {
	        _super.apply(this, arguments);
	        this.is = 'pds-reporting-term-selector';
	        this.properties = {
	            reportingTerms: {
	                type: Array,
	                observer: 'setPossibleReportingTerms'
	            }
	        };
	    }
	    PdsReportingTermSelector.prototype.ready = function () {
	        if (this.possibleReportingTerms == null) {
	            this.possibleReportingTerms = [];
	        }
	    };
	    PdsReportingTermSelector.prototype.messageKeysUpdated = function () { };
	    PdsReportingTermSelector.prototype.reportingTermChange = function (event) {
	        event.preventDefault();
	        this.fire('reporting-term-change', this.selectedReportingTerm);
	    };
	    PdsReportingTermSelector.prototype.setPossibleReportingTerms = function () {
	        if (this.reportingTerms == null) {
	            return;
	        }
	        var different = this.possibleReportingTerms == null || this.possibleReportingTerms.length !== this.reportingTerms.length;
	        var newReportingTerms = [];
	        for (var x = 0; x < this.reportingTerms.length; x++) {
	            if (!different && this.possibleReportingTerms[x].value !== this.reportingTerms[x]) {
	                different = true;
	            }
	            newReportingTerms.push({
	                text: this.reportingTerms[x],
	                value: this.reportingTerms[x]
	            });
	        }
	        if (different) {
	            this.possibleReportingTerms = newReportingTerms;
	        }
	    };
	    return PdsReportingTermSelector;
	}(PdsWidget_1.PdsWidget));
	exports.PdsReportingTermSelector = PdsReportingTermSelector;
	


/***/ }),
/* 24 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var PdsSearch = (function (_super) {
	    __extends(PdsSearch, _super);
	    function PdsSearch() {
	        _super.apply(this, arguments);
	        this.is = 'pds-search';
	    }
	    PdsSearch.prototype.attached = function () {
	        var _this = this;
	        document.body.addEventListener('click', function () {
	            _this.searchQuery = '';
	        });
	    };
	    PdsSearch.prototype.messageKeysUpdated = function () { };
	    PdsSearch.prototype.iconClickHandler = function () {
	        this.querySelector('input').focus();
	    };
	    PdsSearch.prototype.inputChange = function (event) {
	        this.searchQuery = event.target.value;
	        this.debounce('pdsInputChangeFire', function () {
	            this.fire('pdsInputChange', this.searchQuery.trim());
	        }, 250);
	    };
	    PdsSearch.prototype.getInputClass = function (searchQuery) {
	        return searchQuery != null && searchQuery.trim().length > 0 ? 'expanded' : '';
	    };
	    PdsSearch.prototype.isSearchQueryOverLimit = function (searchQuery) {
	        return searchQuery != null && searchQuery.trim().length > 1;
	    };
	    PdsSearch.prototype.studentClickHandler = function (event) {
	        event.preventDefault();
	        event.stopPropagation();
	        var target = event.target;
	        if (!this.pds.utils.is(target, 'a')) {
	            target = this.pds.utils.getClosest(target, 'a');
	        }
	        var student = target.dataStudent;
	        this.fire('pdsStudentClick', student.uid);
	        this.searchQuery = '';
	    };
	    return PdsSearch;
	}(PdsWidget_1.PdsWidget));
	exports.PdsSearch = PdsSearch;
	


/***/ }),
/* 25 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var xlinkns = 'http://www.w3.org/1999/xlink';
	var PdsIcon = (function (_super) {
	    __extends(PdsIcon, _super);
	    function PdsIcon() {
	        _super.apply(this, arguments);
	        this.is = 'pds-icon';
	        this.properties = {
	            name: {
	                type: String,
	                observer: '_nameObserver'
	            }
	        };
	    }
	    PdsIcon.prototype.messageKeysUpdated = function () {
	    };
	    PdsIcon.prototype._nameObserver = function () {
	        var elements = this.querySelectorAll('use');
	        if (elements != null && elements.length === 2) {
	            elements[0].setAttributeNS(xlinkns, 'xlink:href', '#' + this.name);
	            elements[1].setAttributeNS(xlinkns, 'xlink:href', powerSchoolDesignSystemToolkit.svgSpritePath + '#' + this.name);
	        }
	    };
	    return PdsIcon;
	}(PdsWidget_1.PdsWidget));
	exports.PdsIcon = PdsIcon;
	


/***/ }),
/* 26 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var pds_abstract_input_widget_1 = __webpack_require__(2);
	var rich_text_editor_configurations_1 = __webpack_require__(27);
	var PdsRichTextEditor = (function (_super) {
	    __extends(PdsRichTextEditor, _super);
	    function PdsRichTextEditor() {
	        _super.apply(this, arguments);
	        this.is = 'pds-rich-text-editor';
	        this.properties = {
	            name: {
	                type: String,
	                value: ''
	            },
	            dataBadgeText: {
	                type: String,
	                value: '',
	                observer: 'setUpBadge'
	            },
	            dataHideUnelevatedBadge: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataDisableInvalidBadgeElevation: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataIsrequired: {
	                type: String,
	                value: 'false',
	                observer: 'setUpBadge'
	            },
	            dataMaxlength: String,
	            dataIsAdvanced: {
	                type: String,
	                observer: 'initializeEditor'
	            },
	            dataIsreadonly: String,
	            dataNoToolbar: String
	        };
	    }
	    PdsRichTextEditor.prototype.generateValidationRules = function () {
	        var validationRules = this.pds.validationEngine.getBasicValidationRules();
	        validationRules.isRequired = true;
	        validationRules.isText = true;
	        validationRules.setProperty('maxLength', this.dataMaxlength, Number);
	        this.validators = this.pds.validationEngine.getValidatorsForRules(validationRules);
	        if (this.hasOwnProperty('dataCustomvalidate')) {
	            this.validators.push({
	                execute: this.pds.validation.getCustomValidate(this.dataCustomvalidate)
	            });
	        }
	    };
	    PdsRichTextEditor.prototype.showBadge = function (dataBadgeText) {
	        return (dataBadgeText != null && dataBadgeText.length > 0);
	    };
	    PdsRichTextEditor.prototype.getOptions = function () {
	        var options;
	        if (this.dataIsreadonly === 'true') {
	            options = rich_text_editor_configurations_1.readOnlyOptions;
	        }
	        else if (this.dataIsAdvanced === 'true') {
	            options = rich_text_editor_configurations_1.advancedOptions;
	        }
	        else if (this.dataNoToolbar === 'true') {
	            options = rich_text_editor_configurations_1.noToolbarOptions;
	        }
	        else {
	            options = rich_text_editor_configurations_1.basicOptions;
	        }
	        options.wordcount.maxCharCount = this.dataMaxlength;
	        return options;
	    };
	    PdsRichTextEditor.prototype.attached = function () {
	        _super.prototype.attached.call(this);
	        this.initializeEditor();
	    };
	    PdsRichTextEditor.prototype.initializeEditor = function () {
	        var _this = this;
	        if (this.editor != null) {
	            var data = this.modelValue;
	            this.editor.focusManager.blur(true);
	            this.editor.destroy(true);
	            this.editor = CKEDITOR.replace(this.name + '-rich-text-editor', this.getOptions());
	            this.editor.setData(data);
	        }
	        else {
	            this.editor = CKEDITOR.replace(this.name + '-rich-text-editor', this.getOptions());
	        }
	        this.editor.on('change', function () {
	            if (!_this.ignoreEditorChange) {
	                _this.inputChange();
	            }
	        });
	    };
	    PdsRichTextEditor.prototype.messageKeysUpdated = function () {
	    };
	    Object.defineProperty(PdsRichTextEditor.prototype, "value", {
	        get: function () {
	            if (this.editor != null) {
	                return this.editor.getData();
	            }
	        },
	        enumerable: true,
	        configurable: true
	    });
	    Object.defineProperty(PdsRichTextEditor.prototype, "modelValue", {
	        get: function () {
	            if (this.editor != null) {
	                return this.editor.getData();
	            }
	        },
	        set: function (value) {
	            this.ignoreEditorChange = true;
	            var modelValueChanged = this.setModelValue(value);
	            if (modelValueChanged) {
	                this.validateWidget();
	            }
	            this.ignoreEditorChange = false;
	        },
	        enumerable: true,
	        configurable: true
	    });
	    PdsRichTextEditor.prototype.setValue = function (value, skip) {
	        if (skip === void 0) { skip = false; }
	        if (value == null) {
	            value = '';
	        }
	        if (this.editor != null && value !== this.editor.getData()) {
	            this.editor.setData(value);
	        }
	        if (skip !== true) {
	            this.setModelValue(value, true);
	        }
	    };
	    PdsRichTextEditor.prototype.setModelValue = function (modelValue, skip) {
	        if (this.editor != null && modelValue !== this.editor.getData()) {
	            this.editor.setData(modelValue);
	            if (skip !== true) {
	                this.setValue(modelValue, true);
	            }
	            return true;
	        }
	        return false;
	    };
	    return PdsRichTextEditor;
	}(pds_abstract_input_widget_1.PdsAbstractInputWidget));
	exports.PdsRichTextEditor = PdsRichTextEditor;
	


/***/ }),
/* 27 */
/***/ (function(module, exports) {

	"use strict";
	exports.basicOptions = {
	    toolbar: [
	        { name: 'basicstyles', items: ['Bold', 'Italic', 'Underline'] },
	        { name: 'font', items: ['TextColor', 'BGColor', 'FontSize', 'Scayt'] },
	        { name: 'formatting', items: ['JustifyLeft', 'JustifyCenter'] },
	        { name: 'paragraphstyles', items: ['BulletedList', 'NumberedList', 'Table'] },
	        { name: 'externallinks', items: ['Link', 'Unlink', '-', 'Image', 'PasteFromWord'] }
	    ],
	    customConfig: '',
	    extraPlugins: 'justify,font,colorbutton,autoembed,embedsemantic,image2,wordcount',
	    removePlugins: 'image,elementspath',
	    wordcount: {
	        showParagraphs: false,
	        showWordCount: false,
	        showCharCount: true,
	        countHTML: true,
	        maxCharCount: -1
	    },
	    bodyClass: 'article-editor',
	    format_tags: 'p;h1;h2;h3;pre',
	    removeDialogTabs: 'image:advanced;link:advanced'
	};
	exports.readOnlyOptions = {
	    toolbar: [{ name: 'emptyToolbar', items: [] }],
	    customConfig: '',
	    extraPlugins: 'justify,font,colorbutton,autoembed,embedsemantic,image2,wordcount',
	    removePlugins: 'image',
	    wordcount: {
	        showParagraphs: false,
	        showWordCount: false,
	        showCharCount: true,
	        countHTML: true,
	        maxCharCount: -1
	    },
	    bodyClass: 'article-editor',
	    format_tags: 'p;h1;h2;h3;pre',
	    removeDialogTabs: 'image:advanced;link:advanced',
	    readOnly: true,
	    allowedContent: true
	};
	exports.noToolbarOptions = {
	    toolbar: [{ name: 'noToolbar', items: [] }],
	    customConfig: '',
	    extraPlugins: 'justify,font,colorbutton,autoembed,embedsemantic,image2,wordcount',
	    removePlugins: 'image,elementspath',
	    wordcount: {
	        showParagraphs: false,
	        showWordCount: false,
	        showCharCount: true,
	        countHTML: true,
	        maxCharCount: -1
	    },
	    bodyClass: 'article-editor',
	    format_tags: 'p;h1;h2;h3;pre',
	    removeDialogTabs: 'image:advanced;link:advanced'
	};
	exports.advancedOptions = {
	    toolbar: [
	        { name: 'clipboard', items: ['Undo', 'Redo'] },
	        { name: 'styles', items: ['Styles', 'Format'] },
	        { name: 'basicstyles', items: ['Bold', 'Italic', 'Strike', '-', 'RemoveFormat'] },
	        { name: 'paragraph', items: ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote'] },
	        { name: 'links', items: ['Link', 'Unlink'] },
	        { name: 'insert', items: ['Image', 'EmbedSemantic', 'Table'] },
	        { name: 'tools', items: ['Maximize'] },
	        { name: 'editing', items: ['Scayt'] }
	    ],
	    customConfig: '',
	    extraPlugins: 'justify,font,colorbutton,autoembed,embedsemantic,image2,wordcount',
	    removePlugins: 'image',
	    bodyClass: 'article-editor',
	    format_tags: 'p;h1;h2;h3;pre',
	    removeDialogTabs: 'image:advanced;link:advanced',
	    wordcount: {
	        showParagraphs: false,
	        showWordCount: false,
	        showCharCount: true,
	        countHTML: true,
	        maxCharCount: -1
	    },
	    stylesSet: [
	        { name: 'Marker', element: 'span', attributes: { 'class': 'marker' } },
	        { name: 'Cited Work', element: 'cite' },
	        { name: 'Inline Quotation', element: 'q' },
	        {
	            name: 'Special Container',
	            element: 'div',
	            styles: {
	                padding: '5px 10px',
	                background: '#eee',
	                border: '1px solid #ccc'
	            }
	        },
	        {
	            name: 'Compact table',
	            element: 'table',
	            attributes: {
	                cellpadding: '5',
	                cellspacing: '0',
	                border: '1',
	                bordercolor: '#ccc'
	            },
	            styles: {
	                'border-collapse': 'collapse'
	            }
	        },
	        { name: 'Borderless Table', element: 'table', styles: { 'border-style': 'hidden', 'background-color': '#E6E6FA' } },
	        { name: 'Square Bulleted List', element: 'ul', styles: { 'list-style-type': 'square' } },
	        { name: 'Illustration', type: 'widget', widget: 'image', attributes: { 'class': 'image-illustration' } },
	        { name: '240p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-240p' } },
	        { name: '360p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-360p' } },
	        { name: '480p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-480p' } },
	        { name: '720p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-720p' } },
	        { name: '1080p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-1080p' } }
	    ]
	};
	


/***/ }),
/* 28 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var PdsWidget_1 = __webpack_require__(3);
	var PdsImg = (function (_super) {
	    __extends(PdsImg, _super);
	    function PdsImg() {
	        _super.apply(this, arguments);
	        this.is = 'pds-img';
	        this.properties = {
	            src: String,
	            fallbackIconName: String,
	            alt: String,
	            width: Number,
	            height: Number
	        };
	    }
	    PdsImg.prototype.messageKeysUpdated = function () {
	    };
	    PdsImg.prototype.ready = function () {
	        this.useImage = true;
	        this.alt = 'PowerSchool image';
	    };
	    PdsImg.prototype.onImageError = function () {
	        this.useImage = false;
	    };
	    PdsImg.prototype.attached = function () {
	        if (this.fallbackIconName == null || this.fallbackIconName.length === 0) {
	            throw 'Must configure a fallBackIconName';
	        }
	    };
	    return PdsImg;
	}(PdsWidget_1.PdsWidget));
	exports.PdsImg = PdsImg;
	


/***/ })
/******/ ]);
//# sourceMappingURL=02-pds-toolkit.js.map

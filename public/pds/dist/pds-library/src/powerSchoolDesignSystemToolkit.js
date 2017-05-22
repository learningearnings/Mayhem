"use strict";
var PdsDateWidget_1 = require('./PdsDateWidget');
var PdsDateWidgetDialog_1 = require('./PdsDateWidgetDialog');
var PdsDynamicSelect_1 = require('./PdsDynamicSelect');
var PdsTextWidget_1 = require('./PdsTextWidget');
var PdsNumberWidget_1 = require('./PdsNumberWidget');
var pdsLogger_1 = require('./pdsLogger');
var pdsI18n_1 = require('./pdsI18n');
var pdsUtils_1 = require('./pdsUtils');
var pdsValidation_1 = require('./pdsValidation');
var PdsAppSwitcherWidget_1 = require('./PdsAppSwitcherWidget');
var PdsNumberedSlider_1 = require('./PdsNumberedSlider');
var PdsNaturalSort_1 = require('./PdsNaturalSort');
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

//# sourceMappingURL=powerSchoolDesignSystemToolkit.js.map

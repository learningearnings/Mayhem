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

//# sourceMappingURL=pdsValidation.js.map

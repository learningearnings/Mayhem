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

//# sourceMappingURL=PdsDynamicSelect.js.map

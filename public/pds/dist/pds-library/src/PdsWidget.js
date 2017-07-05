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

//# sourceMappingURL=PdsWidget.js.map

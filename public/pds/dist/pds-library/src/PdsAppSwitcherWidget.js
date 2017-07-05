"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var PdsWidget_1 = require('./PdsWidget');
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

//# sourceMappingURL=PdsAppSwitcherWidget.js.map

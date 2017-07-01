"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var PdsWidget_1 = require('./PdsWidget');
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

//# sourceMappingURL=PdsNumberedSlider.js.map

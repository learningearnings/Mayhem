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

//# sourceMappingURL=pdsUtils.js.map

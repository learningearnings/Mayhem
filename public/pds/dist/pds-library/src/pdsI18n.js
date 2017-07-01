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

//# sourceMappingURL=pdsI18n.js.map

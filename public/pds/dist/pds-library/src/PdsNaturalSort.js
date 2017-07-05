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

//# sourceMappingURL=PdsNaturalSort.js.map

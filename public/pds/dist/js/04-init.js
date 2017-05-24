/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
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
/******/ 	// identity function for calling harmony imports with the correct context
/******/ 	__webpack_require__.i = function(value) { return value; };
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 9);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Config = (function () {
    function Config() {
    }
    Config.getAuthorizedRequest = function (url, opts) {
        return ApiAjaxRequest('unified_classroom', 'excludeUserInfo', 'isCors').get(url, opts);
    };
    Config.postAuthorizedRequest = function (url, opts) {
        return ApiAjaxRequest('unified_classroom', 'excludeUserInfo', 'isCors').post(url, opts);
    };
    Config.getUserAccountUid = function () {
        return this.userInfo.userAccountUid;
    };
    Config.getUserDistrictUid = function () {
        return this.userInfo.districtUid;
    };
    Config.getUserType = function () {
        return this.userInfo.userType;
    };
    Config.getUserSourceSystemId = function () {
        return this.userInfo.sourceSystemId;
    };
    Config.getUserInfo = function () {
        return this.userInfo;
    };
    Config.setUserInfo = function (newObj) {
        this.userInfo = newObj;
    };
    Config.getUserName = function () {
        return {
            firstName: HaikuContext.user.first_name,
            lastName: HaikuContext.user.last_name
        };
    };
    Config.onContextChanged = function (ctxManager) {
        if (ctxManager.isClassGroupSelected()) {
            jQuery('#return-to-lms-picker').show();
            jQuery('#return-to-lms-picker').unbind('click').click(function () {
                ctxManager.redirectToLearningClassPicker();
            });
        }
        else {
            jQuery('#return-to-lms-picker').hide();
        }
    };
    Config.handleInternalLink = function (nav, ctxManager) {
        var navInfo = nav.context;
        var route = navInfo.route;
        route = route.replace('_cpuid={userId}', '');
        route = route.replace('ucCtx={unifiedClassroomContext}', '');
        window.location.href = route;
    };
    return Config;
}());
Config.UC_HOST = '';
Config.PRODUCT_CODE = 'LEARNING EARNIGNS';
exports.Config = Config;
/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var schedule_http_1 = __webpack_require__(2);
var user_http_1 = __webpack_require__(4);
var student_http_1 = __webpack_require__(3);
var config_1 = __webpack_require__(0);
var ContextManager = (function () {
    function ContextManager() {
        this.context = {};
        this.productAccountInfo = {};
        if (this.loadContextFromUrl()) {
            this.saveContextToLocalStorage();
        }
        else {
            this.loadContextFromLocalStorage();
        }
        this.selectedTermId = this.context.termId;
        this.selectedYear = parseInt(this.context.yearId);
    }
    ContextManager.prototype.redirectToLearningClassPicker = function (appDestination) {
        var _this = this;
        if (!this.context) {
            return;
        }
        this.getCurrentClassSchedule().then(function () {
            var params = '';
            if (_this.context.sectionId) {
                params = jQuery.param({
                    class_eids: _this.context.sectionId
                });
            }
            else if (_this.isClassGroupSelected()) {
                var classGrouping = _this.findClassGrouping(_this.context.groupType, _this.context.groupName);
                var classEids = classGrouping && classGrouping.sectionUids && (classGrouping.sectionUids.length > 0) && _this.getClassSourceSystemIdsFromUids(classGrouping.sectionUids);
                if (classEids.length > 0) {
                    params = jQuery.param({
                        class_eids: classEids.join(',')
                    });
                }
            }
            if (!params) {
                params = jQuery.param({
                    all: 'true'
                });
            }
            appDestination = appDestination || 'pages';
            var redirectUrl = "/do/go/to/" + appDestination + "?" + params;
            window.location.href = redirectUrl;
        });
    };
    ContextManager.prototype.getScheduleContext = function () {
        var _this = this;
        return this.getYearsAndCurrentTerms().then(function (yearsAndTerms) {
            _this.setSelectedYearSchedulingTermsFromYearsAndTerms();
            return _this.getCurrentClassSchedule().then(function (classSchedule) {
                var justYears = yearsAndTerms.map(function (year) {
                    return year.year;
                });
                return {
                    classSchedule: classSchedule,
                    years: justYears,
                    terms: _this.getTermNames()
                };
            });
        });
    };
    ContextManager.prototype.getTermNames = function () {
        return this.getSelectedYearSchedulingTerms().map(function (term) {
            return term.name;
        });
    };
    ContextManager.prototype.changeClass = function (newClassOrGroup) {
        var shouldRedirect;
        if (newClassOrGroup.sourceSystemId) {
            shouldRedirect = newClassOrGroup.sourceSystemId !== this.context.sectionId;
            this.updateContext({
                sectionId: newClassOrGroup.sourceSystemId,
                groupName: null,
                groupType: null
            });
        }
        else if (newClassOrGroup.groupName) {
            shouldRedirect = newClassOrGroup.groupName !== this.context.groupName;
            this.updateContext({
                groupName: newClassOrGroup.groupName,
                groupType: newClassOrGroup.groupType,
                sectionId: null
            });
        }
        else {
            return;
        }
        this.updateContext({
            yearId: this.selectedYear,
            termId: this.selectedTermId
        });
        this.saveContextToLocalStorage();
        if (shouldRedirect) {
            this.redirectToLearningClassPicker();
        }
    };
    ContextManager.prototype.changeTermAndUpdateSchedule = function (newTermName) {
        var selectedTerm = this.findTermByName(newTermName);
        if (selectedTerm === null) {
            this.selectedTermId = null;
            this.classSchedule = null;
            return jQuery.when(null);
        }
        this.selectedTermId = selectedTerm.name;
        return this.updateSchedule(selectedTerm);
    };
    ContextManager.prototype.updateSchedule = function (term) {
        var _this = this;
        return schedule_http_1.ScheduleHttp.getClassScheduleByTerm(term.schoolDateRanges, this.getSelectedStudentUid()).then(function (classSchedule) {
            _this.setClassSchedule(classSchedule);
            return _this.classSchedule;
        });
    };
    ContextManager.prototype.changeYearAndUpdateTerms = function (newYear) {
        var _this = this;
        var numericYear = parseInt(newYear);
        var newSelectedYear = this.yearsAndTerms.find(function (yearAndTerms) {
            return yearAndTerms.year === numericYear;
        });
        this.selectedYear = newSelectedYear && newSelectedYear.year;
        if (this.selectedYear === null) {
            this.selectedYearSchedulingTerms = null;
            return this.changeTermAndUpdateSchedule(null);
        }
        else {
            return schedule_http_1.ScheduleHttp.getTermsFor(this.selectedYear).then(function (schedulingTerms) {
                _this.selectedYearSchedulingTerms = schedulingTerms;
                var newTerm = (_this.selectedYearSchedulingTerms != null &&
                    _this.selectedYearSchedulingTerms.length > 0) ?
                    _this.selectedYearSchedulingTerms[0].name : null;
                return _this.changeTermAndUpdateSchedule(newTerm);
            });
        }
    };
    ContextManager.prototype.changeStudent = function (newStudentUid) {
        this.selectedStudentUid = newStudentUid;
        return this.updateSchedule(this.getSelectedSchedulingTerm());
    };
    ContextManager.prototype.getContext = function () {
        return this.removeNullProperties(this.context);
    };
    ContextManager.prototype.clear = function () {
        window.localStorage.removeItem(ContextManager.PARAM_NAME);
    };
    ContextManager.prototype.getSelectedClassObject = function () {
        var contextObj = this.context;
        var selectedClassObject = null;
        if (contextObj != null) {
            if (contextObj.sectionId != null) {
                selectedClassObject = this.classSchedule.sections.find(function (section) {
                    return String(section.sourceSystemId) === contextObj.sectionId;
                });
            }
            else if (contextObj.groupName != null && contextObj.groupType != null) {
                selectedClassObject = this.findClassGrouping(contextObj.groupType, contextObj.groupName);
                if (!selectedClassObject) {
                    selectedClassObject = this.classSchedule.sections[0];
                }
            }
        }
        return selectedClassObject;
    };
    ContextManager.prototype.getSelectedYear = function () {
        return this.selectedYear;
    };
    ContextManager.prototype.getSelectedSchedulingTermId = function () {
        return this.selectedTermId;
    };
    ContextManager.prototype.convertNavLinks = function (inputLinks) {
        var _this = this;
        var routeIt = function (nav, event) {
            var url;
            var hostName;
            var navInfo = nav.context;
            var route = navInfo.route;
            if (nav.section != null) {
                route = route.replace('{sectionId}', nav.section.sourceSystemId);
            }
            hostName = /^(http|https):\/\//i.test(route) ? '' : navInfo.hostName;
            route = _this.updateLinkWithContext(route);
            if ((navInfo.isSis && !navInfo.isPtp) ||
                /SPECIALEDUCATION|ASSESSMENTONTRAC|ANALYTICS/.test(navInfo.productCode.trim().toUpperCase()) ||
                ['SP_QUICK', 'SP_SIDE'].indexOf(navInfo.navGroup) !== -1) {
                url = hostName + route;
                window.open(url, 'portalExternalLink');
            }
            else if (config_1.Config.PRODUCT_CODE === navInfo.productCode.trim().toUpperCase()) {
                config_1.Config.handleInternalLink(nav, _this);
            }
            else {
                url = hostName + route;
                window.location.href = url;
            }
        };
        var isCurrentRoute = function (nav) {
            return nav.context.productCode === 'LEARNING';
        };
        var isPtp = function (inputLink) {
            if (inputLink.productCode === 'SIS-PS') {
                var url = inputLink.url;
                if (/^(http|https):\/\//i.test(url)) {
                    url = url.replace(inputLink.hostName, '');
                }
                return /^\/teachers\/index.html/.test(url);
            }
            return false;
        };
        var navItems = new Array();
        for (var _i = 0, inputLinks_1 = inputLinks; _i < inputLinks_1.length; _i++) {
            var inputLink = inputLinks_1[_i];
            var navItem = {
                id: inputLink.name.replace(/\s/ig, '-').toLowerCase() + '-nav-link',
                name: inputLink.name,
                iconName: inputLink.parentIconName,
                isCurrentRoute: isCurrentRoute
            };
            navItem.children = new Array();
            if (inputLink.children != null && inputLink.children.length > 0) {
                for (var _a = 0, _b = inputLink.children; _a < _b.length; _a++) {
                    var inputChildLink = _b[_a];
                    var outputChildLink = {
                        id: inputChildLink.name.replace(/\s/ig, '-').toLowerCase() + '-nav-link',
                        name: inputChildLink.name,
                        iconName: inputChildLink.parentIconName,
                        isCurrentRoute: isCurrentRoute,
                        onUserClick: routeIt,
                        context: {
                            productCode: inputChildLink.productCode,
                            route: inputChildLink.url,
                            isCp: inputChildLink.productCode === 'CP',
                            hostName: inputChildLink.hostName,
                            navGroup: inputChildLink.navigationGroup,
                            isPtp: isPtp(inputChildLink),
                            isSis: inputChildLink.productCode === 'SIS-PS'
                        }
                    };
                    navItem.children.push(outputChildLink);
                }
            }
            else {
                navItem.onUserClick = routeIt;
                navItem.context = {
                    productCode: inputLink.productCode,
                    isCp: inputLink.productCode === 'CP',
                    route: inputLink.url,
                    hostName: inputLink.hostName,
                    navGroup: inputLink.navigationGroup,
                    isPtp: isPtp(inputLink),
                    isSis: inputLink.productCode === 'SIS-PS'
                };
            }
            navItems.push(navItem);
        }
        return navItems;
    };
    ContextManager.prototype.isClassGroupSelected = function () {
        return this.context.groupName != null && this.context.groupType != null;
    };
    ContextManager.prototype.initUserProductAccount = function () {
        var _this = this;
        if (config_1.Config.getUserType() !== 'PARENT') {
            return jQuery.when(null);
        }
        return user_http_1.UserHttp.getProductAccountInfo().then(function (resp) {
            _this.productAccountInfo.uid = resp.uid;
            _this.productAccountInfo.userType = config_1.Config.getUserType();
            if (_this.productAccountInfo.userType === 'PARENT') {
                return student_http_1.StudentHttp.getStudentsByParentId(_this.productAccountInfo.uid).then(function (resp) {
                    _this.students = resp;
                    _this.selectedStudentUid = (_this.students && _this.students.length > 0 && _this.students[0].uid) || null;
                    return;
                });
            }
        });
    };
    ContextManager.prototype.getStudents = function () {
        return this.students;
    };
    ContextManager.prototype.getSelectedStudentUid = function () {
        return this.selectedStudentUid;
    };
    ContextManager.prototype.updateContext = function (newAttrs) {
        if (newAttrs) {
            this.context = this.removeNullProperties(jQuery.extend(this.context, newAttrs));
            config_1.Config.onContextChanged(this);
        }
    };
    ContextManager.prototype.removeNullProperties = function (obj) {
        var propNames = Object.getOwnPropertyNames(obj);
        for (var i = 0; i < propNames.length; i++) {
            var propName = propNames[i];
            if (obj[propName] === null || obj[propName] === undefined) {
                delete obj[propName];
            }
        }
        return obj;
    };
    ContextManager.prototype.updateLinkWithContext = function (link) {
        var encodeUrlParams = powerSchoolDesignSystemToolkit.utils.getPersistedBoolean('debug');
        var retLink = typeof link === 'string' ? link : link.url;
        var ucCtxAsString = powerSchoolDesignSystemToolkit.utils.stringifyUrlSearchObjectParam(this.getContext(), encodeUrlParams);
        var ctx = {};
        ctx.unifiedClassroomContext = ucCtxAsString;
        if (this.getSelectedClassObject() != null) {
            var selectedSectionSourceIds = this.getSelectedSectionSourceIds();
            if (selectedSectionSourceIds.length > 0) {
                ctx.sectionIds = selectedSectionSourceIds.join(',');
                ctx.sectionId = selectedSectionSourceIds[0];
            }
        }
        if (config_1.Config.getUserType() === 'TEACHER' && config_1.Config.getUserSourceSystemId() != null) {
            ctx.teacherId = config_1.Config.getUserSourceSystemId();
        }
        return powerSchoolDesignSystemToolkit.utils.replaceTokensInString(retLink, ctx);
    };
    ContextManager.prototype.getSelectedSectionSourceIds = function () {
        if (this.getSelectedClassObject().sectionUids) {
            return this.getClassSourceSystemIdsFromUids(this.getSelectedClassObject().sectionUids);
        }
        return [];
    };
    ContextManager.prototype.getCurrentClassSchedule = function () {
        var _this = this;
        if (this.selectedTermId && this.selectedYearSchedulingTerms) {
            return this.changeTermAndUpdateSchedule(this.selectedTermId);
        }
        if (this.classSchedule) {
            return jQuery.when(this.classSchedule);
        }
        else {
            return schedule_http_1.ScheduleHttp.getClassSchedule(this.getSelectedStudentUid()).then(function (classSchedule) {
                _this.setClassSchedule(classSchedule);
                return _this.classSchedule;
            });
        }
    };
    ContextManager.prototype.getYearsAndCurrentTerms = function () {
        var _this = this;
        if (this.yearsAndTerms) {
            return jQuery.when(this.yearsAndTerms);
        }
        else {
            return schedule_http_1.ScheduleHttp.getYearsAndCurrentTerms().then(function (yearsAndTerms) {
                _this.yearsAndTerms = yearsAndTerms;
                return _this.yearsAndTerms;
            });
        }
    };
    ContextManager.prototype.getSelectedYearSchedulingTerms = function () {
        return this.selectedYearSchedulingTerms || [];
    };
    ContextManager.prototype.setSelectedYearSchedulingTermsFromYearsAndTerms = function () {
        for (var _i = 0, _a = this.yearsAndTerms; _i < _a.length; _i++) {
            var yearTerms = _a[_i];
            if (yearTerms.year === this.getSelectedYear() &&
                yearTerms.schedulingTerms &&
                yearTerms.schedulingTerms.length > 0) {
                this.selectedYearSchedulingTerms = yearTerms.schedulingTerms;
            }
        }
    };
    ContextManager.prototype.findClassGrouping = function (groupType, groupName) {
        if (!this.classSchedule) {
            throw "Error: User's class schedule was not initialized.";
        }
        else if (!this.classSchedule.classGrouping) {
            return null;
        }
        var classGrouping;
        var findFunc = function (classGroup) { return classGroup.groupName.toLowerCase() === groupName.toLowerCase(); };
        switch (groupType.toLowerCase()) {
            case 'school':
                classGrouping = this.classSchedule.classGrouping.schoolGroups.find(findFunc);
                break;
            case 'course':
                classGrouping = this.classSchedule.classGrouping.courseGroups.find(findFunc);
                break;
            case 'expression':
                classGrouping = this.classSchedule.classGrouping.expressionGroups.find(findFunc);
                break;
            default:
                classGrouping = null;
        }
        return classGrouping;
    };
    ContextManager.prototype.getClassSourceSystemIdsFromUids = function (classUids) {
        var _this = this;
        var classSourceSytemIds = [];
        classUids.forEach(function (classUid) {
            var section = _this.classSchedule.sections.find(function (section) {
                return section.uid === classUid;
            });
            if (section) {
                classSourceSytemIds.push(section.sourceSystemId);
            }
        });
        return classSourceSytemIds;
    };
    ContextManager.prototype.loadContextFromUrl = function () {
    	/*
        var ctxString = this.getUrlParameter(ContextManager.PARAM_NAME);
        var encodeUrlParams = powerSchoolDesignSystemToolkit.utils.getPersistedBoolean('debug');
        if (ctxString) {
            try {
                this.updateContext(powerSchoolDesignSystemToolkit.utils.parseUrlSearchObjectParam(ctxString, encodeUrlParams));
                return true;
            }
            catch (e) { }
        }
        return false;
        */
       return true;
    };
    ContextManager.prototype.saveContextToLocalStorage = function () {
        if (this.context) {
            window.localStorage.setItem(ContextManager.PARAM_NAME, JSON.stringify(this.context));
        }
    };
    ContextManager.prototype.loadContextFromLocalStorage = function () {
        try {
            this.updateContext(JSON.parse(window.localStorage.getItem(ContextManager.PARAM_NAME)));
        }
        catch (e) { }
    };
    ContextManager.prototype.getUrlParameter = function (paramName) {
        var searchString = window.location.search.substring(1), i, val, params = searchString.split('&');
        for (var i_1 = 0; i_1 < params.length; i_1++) {
            val = params[i_1].split('=');
            if (val[0] === paramName) {
                return val[1];
            }
        }
        return null;
    };
    ContextManager.prototype.setClassSchedule = function (classSchedule) {
        if (classSchedule.sections && classSchedule.sections.length > 0) {
            classSchedule.classGrouping.courseGroups.unshift(this.createAllClassesGroup(classSchedule.sections));
        }
        this.classSchedule = classSchedule;
    };
    ContextManager.prototype.createAllClassesGroup = function (sectionUids) {
        var allClasses = {
            groupType: 'course',
            groupName: 'All Classes',
            sectionUids: sectionUids.map(function (section) {
                return section.uid;
            })
        };
        return allClasses;
    };
    ContextManager.prototype.getSelectedSchedulingTerm = function () {
        return this.findTermByName(this.getSelectedSchedulingTermId());
    };
    ContextManager.prototype.findTermByName = function (newTermName) {
        var term = null;
        if (newTermName) {
            var found = this.selectedYearSchedulingTerms.find(function (term) {
                return term.name.toLowerCase() === newTermName.toLowerCase();
            });
            if (typeof found !== 'undefined') {
                term = found;
            }
        }
        return term;
    };
    return ContextManager;
}());
ContextManager.PARAM_NAME = 'ucCtx';
exports.ContextManager = ContextManager;
/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var config_1 = __webpack_require__(0);
var ScheduleHttp = (function () {
    function ScheduleHttp() {
    }
    ScheduleHttp.getClassSchedule = function (studentUid) {
        return config_1.Config.getAuthorizedRequest(this.getSectionsUrl(studentUid))
            .then(function (classSchedule) {
            return classSchedule;
        });
    };
    ScheduleHttp.getClassScheduleByTerm = function (schoolDateRanges, studentUid) {
        return config_1.Config.postAuthorizedRequest(this.getSectionsUrl(studentUid), { data: schoolDateRanges })
            .then(function (classSchedule) {
            return classSchedule;
        });
    };
    ScheduleHttp.getYearsAndCurrentTerms = function () {
        return config_1.Config.getAuthorizedRequest(this.getCurrentTermsUrl(), {});
    };
    ScheduleHttp.getTermsFor = function (year) {
        return config_1.Config.getAuthorizedRequest(this.getTermsUrlFor(year), {});
    };
    ScheduleHttp.getSectionsUrl = function (studentUid) {
        var sectionsUrl = config_1.Config.UC_HOST + ("/navigation/v1/user/" + config_1.Config.getUserAccountUid() + "/sections");
        if (studentUid) {
            sectionsUrl = sectionsUrl + '?studentUid=' + studentUid;
        }
        return sectionsUrl;
    };
    ScheduleHttp.getCurrentTermsUrl = function () {
        return config_1.Config.UC_HOST + ("/navigation/v1/user/" + config_1.Config.getUserAccountUid() + "/current_terms");
    };
    ScheduleHttp.getTermsUrlFor = function (year) {
        return config_1.Config.UC_HOST + ("/navigation/v1/user/" + config_1.Config.getUserAccountUid() + "/year/" + year + "/terms");
    };
    return ScheduleHttp;
}());
exports.ScheduleHttp = ScheduleHttp;
/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var config_1 = __webpack_require__(0);
var StudentHttp = (function () {
    function StudentHttp() {
    }
    StudentHttp.getStudentsByParentId = function (parentUid) {
        return config_1.Config.getAuthorizedRequest(config_1.Config.UC_HOST + "/navigation/v1/parent/" + parentUid + "/students", {});
    };
    return StudentHttp;
}());
exports.StudentHttp = StudentHttp;
/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var config_1 = __webpack_require__(0);
var UserHttp = (function () {
    function UserHttp() {
    }
    UserHttp.getProductAccountInfo = function () {
        var params = {};
        params.userType = config_1.Config.getUserType();
        params.districtUid = config_1.Config.getUserDistrictUid();
        return config_1.Config.getAuthorizedRequest(config_1.Config.UC_HOST + "/navigation/v1/user_account/" + config_1.Config.getUserAccountUid() + "/user_info/", { data: params });
    };
    return UserHttp;
}());
exports.UserHttp = UserHttp;
/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var config_1 = __webpack_require__(0);
var NavigationHttp = (function () {
    function NavigationHttp() {
    }
    NavigationHttp.getNavigationLinksFor = function (navGroup, ctxManager) {
        return config_1.Config.getAuthorizedRequest(this.getNavigationUrlFor(navGroup), {})
            .then(function (navigationLinks) {
            return ctxManager.convertNavLinks(navigationLinks);
        });
    };
    NavigationHttp.getNavigationUrlFor = function (navGroup) {
        return config_1.Config.UC_HOST + '/navigation/v1/navigationlink?navigationGroups=' + navGroup;
    };
    return NavigationHttp;
}());
exports.NavigationHttp = NavigationHttp;
/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var navigation_http_1 = __webpack_require__(5);
var config_1 = __webpack_require__(0);
var ClassPicker = (function () {
    function ClassPicker(contextManager) {
        this.contextManager = contextManager;
        this.classPickerComponent = document.createElement('pds-class-picker');
        this.classPickerComponent.setAttribute('style', 'text-align:center; width: 100%');
        this.classPickerComponent.selectedClass = {};
        document.querySelector('#pds-class-picker').appendChild(this.classPickerComponent);
        this.initCurrentUserSourceSystemId();
    }
    ClassPicker.prototype.init = function () {
        var _this = this;
        navigation_http_1.NavigationHttp.getNavigationLinksFor('CLASS_PICKER', this.contextManager).then(function (navItems) {
            _this.classPickerComponent.links = navItems;
        });
        this.contextManager.initUserProductAccount().then(function () {
            _this.contextManager.getScheduleContext().then(function (scheduleCtx) {
                if (config_1.Config.getUserType() === 'PARENT') {
                    _this.classPickerComponent.studentOptions = _this.contextManager.getStudents();
                    _this.classPickerComponent.selectedStudent = _this.contextManager.getSelectedStudentUid();
                }
                _this.classPickerComponent.years = scheduleCtx.years;
                _this.classPickerComponent.selectedYear = _this.contextManager.getSelectedYear();
                _this.classPickerComponent.schedulingTerms = scheduleCtx.terms;
                _this.classPickerComponent.selectedSchedulingTerm = _this.contextManager.getSelectedSchedulingTermId();
                _this.classPickerComponent.classSchedule = scheduleCtx.classSchedule;
                _this.classPickerComponent.selectedClass = _this.contextManager.getSelectedClassObject();
            });
        });
        this.classPickerComponent.addEventListener('pdsClassChange', function (ev) {
            _this.contextManager.changeClass(ev.detail);
        });
        var resetYearAndTerms = function () {
            _this.classPickerComponent.selectedYear = _this.contextManager.getSelectedYear();
            _this.classPickerComponent.schedulingTerms = _this.contextManager.getTermNames();
        };
        var resetSchedule = function (classSchedule) {
            _this.classPickerComponent.selectedSchedulingTerm = _this.contextManager.getSelectedSchedulingTermId();
            _this.classPickerComponent.classSchedule = classSchedule;
        };
        this.classPickerComponent.addEventListener('pdsSchedulingTermChange', function (ev) {
            _this.contextManager.changeTermAndUpdateSchedule(ev.detail).then(resetSchedule);
        });
        this.classPickerComponent.addEventListener('pdsYearChange', function (ev) {
            _this.contextManager.changeYearAndUpdateTerms(ev.detail).then(function (classSchedule) {
                resetYearAndTerms();
                resetSchedule(classSchedule);
            });
        });
        this.classPickerComponent.addEventListener('pdsStudentChange', function (ev) {
            _this.contextManager.changeStudent(ev.detail).then(resetSchedule);
        });
    };
    ClassPicker.prototype.getClassBySourceSytemSectionId = function (sourceSystemSectionId) {
        return this.classPickerComponent.classSchedule.sections.find(function (section) {
            return String(section.sourceSystemId) === sourceSystemSectionId;
        });
    };
    ClassPicker.prototype.initCurrentUserSourceSystemId = function () {
        this.currentUserSourceSystemId = config_1.Config.getUserSourceSystemId();
    };
    return ClassPicker;
}());
exports.ClassPicker = ClassPicker;
/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var navigation_http_1 = __webpack_require__(5);
var config_1 = __webpack_require__(0);
var Nav = (function () {
    function Nav(contextManager) {
        this.contextManager = contextManager;
        this.navComponent = document.createElement('pds-app-nav');
        this.navComponent.setAttribute('app-name', 'Classroom');
        this.navComponent.setAttribute('class','pds-app-nav');
        this.navComponent.navigation = new Array();
        this.navComponent.user = {};
        this.navComponent.userNavigation = [];
        //alert($('.unified-classroom-wrapper'));
        jQuery('.pds-app').prepend(this.navComponent);
    }
    Nav.prototype.initLinks = function () {
        var _this = this;
        var navItems = [];
        $.ajax({
  			url: "/navmenus"
		})
  		.done(function( data ) {
    		if ( console && console.log ) {
      			console.log( "Sample of data:", data );
      	    }
  			_this.navComponent.homeNavItem = data["home"] ;
 			_this.navComponent.navigation = data["main"] ;  			
 			_this.navComponent.userNavigation = data["user"] ; 
         	_this.navComponent.user = 'Allen Taylor';	
    
  		});
        //navigation_http_1.NavigationHttp.getNavigationLinksFor('MAIN_NAV', this.contextManager).then(function (navItems) {
            _this.navComponent.homeNavItem = navItems.shift();
            _this.navComponent.navigation = navItems;
    };
    Nav.prototype.initUserInfo = function () {
        //this.navComponent.user = config_1.Config.getUserName();
        //this.navComponent.user = [{name: 'Allen Taylor'}] ;       
    };
    return Nav;
}());
exports.Nav = Nav;
/***/ }),
/* 8 */,
/* 9 */
/***/ (function(module, exports, __webpack_require__) {
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var nav_1 = __webpack_require__(7);
var class_picker_1 = __webpack_require__(6);
var config_1 = __webpack_require__(0);
var context_manager_1 = __webpack_require__(1);
window.powerSchoolDesignSystemToolkit.svgSpritePath = '/pds/dist/img/pds-icons.svg';
window.addEventListener('DOMContentLoaded', function (e) {
    var contextManager = new context_manager_1.ContextManager();
    var navComp = new nav_1.Nav(contextManager);
    //alert('init user info');
    navComp.initUserInfo();
    
    //alert('init links');
    navComp.initLinks();
//    ApiAccessInfo.initAccess('unified_classroom', '/do/account/access_info_uc').then(function (accessInfo) {
//        config_1.Config.setUserInfo(accessInfo);
//        navComp.initLinks();
//        if ((config_1.Config.getUserType() === 'TEACHER') || (config_1.Config.getUserType() === 'PARENT') || (config_1.Config.getUserType() === 'STUDENT')) {
//            var classPicker = new class_picker_1.ClassPicker(contextManager);
//            classPicker.init();
//        }
//    });
});
/***/ })
/******/ ]);
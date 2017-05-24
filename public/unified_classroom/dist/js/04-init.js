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
/******/ 	return __webpack_require__(__webpack_require__.s = 1);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var Nav = (function () {
    function Nav() {
        this.navComponent = document.createElement('pds-app-nav');
        this.navComponent.setAttribute('app-name', 'Classroom');
        this.navComponent.navigation = new Array();
        this.navComponent.user = {};
        this.navComponent.userNavigation = [];
        jQuery('.unified_classroom_wrapper').prepend(this.navComponent);
    }
    Nav.prototype.initLinks = function () {
    	var _this = this;
        $.ajax({
  			url: "/navmenus"
		})
  		.done(function( data ) {
    		if ( console && console.log ) {
      			console.log( "Sample of data:", data );
      	    }
      	    data["home"]["onUserClick"] = function () {
    				var id = $(this).attr('id');
                    window.location = data["routes"][id];
               };
      	    data["main"].forEach(function (entry) {
    			entry["onUserClick"] = function () {
    				var id = $(this).attr('id');
                    window.location = data["routes"][id];
               };
			});	
      	    data["user"].forEach(function (entry) {
    			entry["onUserClick"] = function () {
    				var id = $(this).attr('id');
                    window.location = data["routes"][id];
               };
			});						
  			_this.navComponent.homeNavItem = data["home"] ;
 			_this.navComponent.navigation = data["main"] ;  			
 			_this.navComponent.userNavigation = data["user"] ; 
         	_this.navComponent.user = data['username'];	
    
  		});
  		
    };
    Nav.prototype.initUserInfo = function () {

    };
    return Nav;
}());
exports.Nav = Nav;


/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var nav_1 = __webpack_require__(0);
window.powerSchoolDesignSystemToolkit.svgSpritePath = '/unified_classroom/dist/img/pds-icons.svg';
window.addEventListener('DOMContentLoaded', function (e) {
    var navComp = new nav_1.Nav();
    navComp.initUserInfo();
    navComp.initLinks();
    
});


/***/ })
/******/ ]);
"use strict";
exports.pdsLogger = {
    setLoggerStatus: function (loggerName, showMessages) {
        this.loggerStatus[loggerName] = showMessages;
    },
    loggerStatus: {},
    requiresLogger: function (functionName) {
        if (this.log[functionName] == null) {
            var loggerFunction = function (msg) {
                var params = [];
                for (var _i = 1; _i < arguments.length; _i++) {
                    params[_i - 1] = arguments[_i];
                }
                if (this.loggerStatus[functionName]) {
                    console.log.apply(console, arguments);
                }
            };
            this.log[functionName] = loggerFunction.bind(this);
            if (!this.loggerStatus.hasOwnProperty(functionName)) {
                this.loggerStatus[functionName] = false;
            }
        }
    },
    log: function (msg) {
        var params = [];
        for (var _i = 1; _i < arguments.length; _i++) {
            params[_i - 1] = arguments[_i];
        }
        if (this.loggerStatus.log) {
            console.log.apply(console, arguments);
        }
    }
};

//# sourceMappingURL=pdsLogger.js.map

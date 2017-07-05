export declare let pdsLogger: {
    setLoggerStatus: (loggerName: string, showMessages: boolean) => void;
    loggerStatus: {};
    requiresLogger: (functionName: string) => void;
    log: (msg: any, ...params: any[]) => void;
};

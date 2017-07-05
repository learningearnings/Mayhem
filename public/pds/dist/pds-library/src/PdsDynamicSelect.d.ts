export declare class PdsDynamicSelect {
    is: string;
    extends: string;
    properties: {
        dynamicOptions: {
            observer: string;
        };
        defaultValue: {};
    };
    dynamicOptions: Array<{
        value: any;
        text: string;
    }>;
    defaultValue: any;
    defaultUsed: boolean;
    optionsUpdated(): void;
}

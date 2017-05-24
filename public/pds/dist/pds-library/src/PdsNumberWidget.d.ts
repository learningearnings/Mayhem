import { PdsAbstractInputWidget } from './PdsAbstractInputWidget';
export declare class PdsNumberWidget extends PdsAbstractInputWidget {
    is: string;
    dataIsinteger: string;
    dataMinlength: string;
    dataMaxlength: string;
    dataMaxvalue: string;
    dataMinvalue: string;
    dataMaxdecimals: string;
    dataMinvalue_exclusive: string;
    dataMaxvalue_exclusive: string;
    properties: {
        dataIsinteger: StringConstructor;
        dataMinlength: StringConstructor;
        dataMaxlength: StringConstructor;
        dataMaxvalue: StringConstructor;
        dataMinvalue: StringConstructor;
        dataMaxdecimals: StringConstructor;
        dataMinvalue_exclusive: StringConstructor;
        dataMaxvalue_exclusive: StringConstructor;
        hasHadError: {
            value: boolean;
        };
        name: StringConstructor;
    };
    messageKeysUpdated(): void;
    setValue(value: string, skip?: boolean): void;
    setModelValue(modelValue: number, skip: boolean): boolean;
    isValidNumber(): boolean;
    validateIsInteger(): boolean;
    validateWidget(): boolean;
    validateMaxDecimals(value: any): boolean;
    countDecimals(value: any): number;
}

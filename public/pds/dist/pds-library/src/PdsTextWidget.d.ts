import { PdsAbstractInputWidget } from './PdsAbstractInputWidget';
export declare class PdsTextWidget extends PdsAbstractInputWidget {
    is: string;
    dataRegexErrorText: string;
    dataInputType: string;
    dataRegex: string;
    dataMinlength: string;
    dataMaxlength: string;
    dataExcludechars: string;
    validationRegex: RegExp;
    dataAdditionalInputAttributes: Object;
    dataAdditionalErrorAttributes: Object;
    properties: {
        name: StringConstructor;
        dataLabelText: StringConstructor;
        dataBadgeText: StringConstructor;
        dataHelperText: StringConstructor;
        dataRegexErrorText: StringConstructor;
        dataFieldHelpText: StringConstructor;
        dataPlaceholderText: StringConstructor;
        dataTooltipText: StringConstructor;
        dataInputType: {
            type: StringConstructor;
            value: string;
        };
        dataRegex: {
            type: StringConstructor;
            observer: string;
            notify: boolean;
        };
        dataMinlength: StringConstructor;
        dataMaxlength: StringConstructor;
        dataExcludechars: StringConstructor;
        dataIsrequired: {
            type: BooleanConstructor;
            value: boolean;
            observer: string;
            notify: boolean;
        };
        dataIsreadonly: {
            type: BooleanConstructor;
            value: boolean;
            observer: string;
            notify: boolean;
        };
        hasHadError: {
            value: boolean;
            observer: string;
        };
        dataAdditionalInputAttributes: ObjectConstructor;
        dataAdditionalErrorAttributes: ObjectConstructor;
        dataHideUnelevatedBadge: {
            type: BooleanConstructor;
            value: boolean;
        };
        dataDisableInvalidBadgeElevation: {
            type: BooleanConstructor;
            value: boolean;
        };
    };
    messageKeysUpdated(): void;
    attached(): void;
    ready(): void;
    setAdditionalInputAttributes(): void;
    setAdditionalErrorAttributes(): void;
    showLabel(dataLabelText: string): boolean;
    setOriginalBadgeText(): void;
    setValue(value: string, skip?: boolean): void;
    setModelValue(modelValue: string, skip: boolean): boolean;
    validateWidget(): boolean;
    validateIsRequired(isValid: boolean, isRequired: boolean, inputText: string, fieldBadge: HTMLElement, disableInvalidBadgeElevation: boolean): boolean;
    validateMinLength(isValid: boolean, minLength: string, inputText: string): boolean;
    validateMaxLength(isValid: boolean, maxLength: string, inputText: string): boolean;
    validateRegex(isValid: boolean, regex: RegExp, inputText: string, regexErrorMessage: string): boolean;
    setValidationRegex(validate?: boolean): void;
    handleKeypress(event: any, detail: any, sender: any): boolean;
    isExcludedCharacter(enteredCharacter: string, excludedCharacters: string): boolean;
    toggleTooltip(): void;
}

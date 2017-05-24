import { PdsAbstractInputWidget } from './PdsAbstractInputWidget';
export declare class PdsDateWidget extends PdsAbstractInputWidget {
    is: string;
    name: string;
    dataMaxdate: string;
    dataMindate: string;
    dataMaxdate_exclusive: string;
    dataMindate_exclusive: string;
    buttonText: string;
    properties: {
        name: StringConstructor;
        dataLabelText: StringConstructor;
        dataBadgeText: StringConstructor;
        dataHelperText: StringConstructor;
        dataRegexErrorText: StringConstructor;
        dataFieldHelpText: StringConstructor;
        dataPlaceholderText: StringConstructor;
        dataTooltipText: StringConstructor;
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
        dataMaxdate: StringConstructor;
        dataMindate: StringConstructor;
        dataMaxdate_exclusive: StringConstructor;
        dataMindate_exclusive: StringConstructor;
    };
    dialogValue: Date;
    showDatePickerDialog: boolean;
    ready(): void;
    messageKeysUpdated(): void;
    dateChanged(e: any): void;
    setValue(value: any, skip?: boolean): void;
    setModelValue(modelValue: Date, skip?: boolean): boolean;
    openDatePickerDialog(): void;
    closeDatePickerDialog(): void;
    isValidDate(): boolean;
    validateWidget(): boolean;
}

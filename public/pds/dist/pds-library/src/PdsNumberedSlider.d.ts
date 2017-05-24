import { PdsWidget } from './PdsWidget';
export declare class PdsNumberedSlider extends PdsWidget {
    is: string;
    value: number;
    max: number;
    properties: {
        min: NumberConstructor;
        max: {
            type: NumberConstructor;
            observer: string;
        };
        value: {
            type: NumberConstructor;
            observer: string;
        };
        name: StringConstructor;
    };
    modelValue: number;
    valueChanged(value: any): void;
    maxChanged(max: any): void;
    attributeChanged(name: string, type: any): void;
    ready(): void;
    updateNumber: () => void;
    messageKeysUpdated(): void;
}

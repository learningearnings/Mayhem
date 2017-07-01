import { PdsWidget } from './PdsWidget';
import { CalendarDay } from './interfaces/calendar-day';
export declare class PdsDateWidgetDialog extends PdsWidget {
    is: string;
    monthLabels: Array<{
        value: string;
        text: string;
    }>;
    pds: any;
    dayLabels: Array<string>;
    todayTimeStamp: number;
    dataMaxdate: string;
    maxDateTimeStamp: number;
    dataMindate: string;
    minDateTimeStamp: number;
    value: Date;
    days: Array<CalendarDay>;
    month: string;
    year: string;
    holdRefresh: boolean;
    possibleYears: Array<{
        value: string;
        text: string;
    }>;
    yearIncrement: boolean;
    properties: {
        month: {
            type: StringConstructor;
            observer: string;
        };
        year: {
            type: StringConstructor;
            observer: string;
        };
        possibleYears: {
            type: ArrayConstructor;
        };
        dataMaxdate: {
            type: StringConstructor;
        };
        dataMindate: {
            type: StringConstructor;
        };
    };
    setMonthLabels(): void;
    ready(): void;
    getSelectedMonth(index: any): boolean;
    getSelectedYear(yearValue: any): boolean;
    getSelectedDateClass(dateTimeStamp: any, value: any): string | undefined;
    getTodayClass(dateTimeStamp: any): string | undefined;
    getIsWeekendClass(isWeekend: any): string | undefined;
    getInvisibleClass(dayNum: any): string | undefined;
    getDisabledItemClass(dateTimeStamp: any): string | undefined;
    isTimeStampDisabled(dateTimeStamp: any): boolean;
    selectDate(event: any): void;
    monthChange(): void;
    yearChange(): void;
    updateAvailableYears(year: any): void;
    previousMonth(): void;
    nextMonth(): void;
    setDate(dateTimeString: any): void;
    updateDays(): void;
    messageKeysUpdated(): void;
}

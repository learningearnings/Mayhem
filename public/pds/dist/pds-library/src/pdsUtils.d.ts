import { CalendarDay } from './interfaces/calendar-day';
export declare let pdsUtils: {
    pds: undefined;
    ESCAPE_USER_INPUT_REGEX: RegExp;
    escapeUserInput(userInput: string): string;
    isMobile: () => boolean;
    dateToTime: (date: Date) => number | undefined;
    getClosest: (element: HTMLElement, selector: string) => {
        querySelector: (string: any) => any;
    } | undefined;
    is: (element: HTMLElement, selector: string) => boolean | undefined;
    addClass(element: HTMLElement, className: string): void;
    removeClass(element: HTMLElement, className: string): void;
    flatten(arry: any[]): any[];
    generateDays(year: number, month: number, fillBlankDays?: boolean): CalendarDay[];
};

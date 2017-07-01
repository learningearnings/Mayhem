export declare class PdsNaturalSort {
    naturalCompare: (a: any, b: any) => number;
    alphabet: string | null;
    emptyAsNull: boolean;
    isAscending: boolean;
    isIgnoreCase: boolean;
    key: string | null;
    nulls: string;
    constructor();
    clearKey(): void;
    setAlphabet(str: string): void;
    setAscending(value: boolean): void;
    setEmptyAsNull(value: boolean): void;
    setIgnoreCase(value: boolean): void;
    setKey(value: string): void;
    setNulls(value: any): void;
    ascending(): void;
    descending(): void;
    ignoreCase(): void;
    nullsAsc(): void;
    nullsDesc(): void;
    nullsFirst(): void;
    nullsLast(): void;
    useCase(): void;
    reset(): void;
    naturalSort(arr: Array<any>, key: string): Array<any>;
}

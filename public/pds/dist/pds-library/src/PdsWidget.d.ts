export declare abstract class PdsWidget {
    pds: any;
    abstract messageKeysUpdated(): void;
    ready(): void;
    addMessageKeyUpdatedClass(): void;
    removeMessgeKeyUpdatedClass(): void;
    querySelector(param: string): any;
    dispatchEvent(e: Event): void;
}

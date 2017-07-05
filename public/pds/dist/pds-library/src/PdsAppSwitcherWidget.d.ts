import { PdsWidget } from './PdsWidget';
export declare class PdsAppSwitcherWidget extends PdsWidget {
    is: string;
    showApps: boolean;
    apps: Array<{
        title: string;
        href: string;
        id: string;
    }>;
    plugins: Array<{
        title: string;
        href: string;
    }>;
    classLookup: {
        [key: string]: string;
    };
    messageKeysUpdated(): void;
    getIconClass(classLookupKey: any): string;
    ready(): void;
    openAppSwitcher(event: any): void;
    close(): void;
}

namespace App {
  export type FlashType = "notice" | "error" | "info" | "warning" | "success";

  export type Flash = Partial<Record<FlashType, string>>;

  export interface User {}

  export interface SharedProps {
    current_user: User;
    flash: Flash;
    [key: string]: unknown;
  }
}

// add `& (string | number)` to the keyof ObjectType
declare type NestedKeyOf<ObjectType extends object> = {
  [Key in keyof ObjectType & (string | number)]: ObjectType[Key] extends object
    ? `${Key}` | `${Key}.${NestedKeyOf<ObjectType[Key]>}`
    : `${Key}`;
}[keyof ObjectType & (string | number)];

declare type WithOptional<Type, Key extends keyof Type> = Type & {
  [Property in Key]-?: Type[Property];
};

namespace App {
  export interface Exception {
    id: number;
    visit_id: number;
    user_id: number;
    name: string;
    properties: {
      url: string;
      host: string;
      path: string;
      format: string;
      params: Record<string, string>;
      message: string;
      backtrace: string[];
      exception: string;
    };
    time: string;
    tenant_id: number;
  }
}

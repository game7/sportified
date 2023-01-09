import { FormDataConvertible } from "@inertiajs/inertia";
import { Form, FormItemProps } from "antd";
import _, { get, isPlainObject } from "lodash";
import { humanize } from "./inflector";
import { useErrors } from "./use-errors";

// hook to wrap antd useForm hook and include
// model binding helper
export function useForm<T extends object>(model?: T) {
  const [form] = Form.useForm<T>();
  const [errorsFor] = useErrors<T>();

  function bind(attr: NestedKeyOf<T>): Partial<FormItemProps<T>> {
    const path = (attr as string).split(".");
    return {
      name: path,
      label: humanize(path.join(" ")),
      initialValue: getInitialValue<T>(model, attr),
      ...errorsFor(attr),
    };
  }

  return { form, bind };
}

function getInitialValue<T extends object>(
  model: T | undefined,
  attr: NestedKeyOf<T>
) {
  let value = model && get(model, attr);
  return value === null ? "" : value;
}

export function asPayload<TModel extends Record<string, any>>(
  model: TModel,
  ...nestedAttributes: string[]
): Record<string, FormDataConvertible> {
  if (!nestedAttributes.length) {
    return model as Record<string, FormDataConvertible>;
  }

  const attrs = new Set(nestedAttributes);
  return deepTransformKeys(model, (_obj, key) => {
    return attrs.has(key) ? `${key}_attributes` : key;
  }) as Record<string, FormDataConvertible>;
}

function deepTransformKeys(
  object: any,
  callback: (value: any, key: string) => string
): any {
  if (!isPlainObject(object)) {
    return object;
  }

  return _(object)
    .mapKeys(callback)
    .mapValues((value) => deepTransformKeys(value, callback))
    .value();
}

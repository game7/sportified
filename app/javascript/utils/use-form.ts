import { FormDataConvertible } from "@inertiajs/inertia";
import _, { get, isPlainObject, toString } from "lodash";
import { humanize } from "./inflector";
import { useErrors } from "./use-errors";
import { useForm as mantineUseForm } from "@mantine/form";
import { GetInputProps } from "@mantine/form/lib/types";

type useFormParams<T> = Parameters<typeof mantineUseForm>[0];

// hook to wrap antd useForm hook and include
// model binding helper
export function useForm<T extends object>(
  model?: T,
  options?: useFormParams<T>
) {
  const form = mantineUseForm<T>({
    initialValues: options?.initialValues || model,
  });
  const [errorsFor] = useErrors<T>();

  const bind: GetInputProps<T> = (path, options) => {
    const props = form.getInputProps(path, options);
    if ("value" in props && !props.value) {
      props.value = "";
    }
    return {
      ...props,
      label: humanize(toString(path).split(".").pop()),
      // initialValue: getInitialValue<T>(model, attr),
      ...errorsFor(path.toString()),
    };
  };

  return { form, bind };
}

// function getInitialValue<T extends object>(
//   model: T | undefined,
//   attr: NestedKeyOf<T>
// ) {
//   let value = model && get(model, attr);
//   return value === null ? "" : value;
// }

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

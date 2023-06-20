import {
  LooseKeys,
  UseFormReturnType,
  _TransformValues,
} from "@mantine/form/lib/types";
import { humanize } from "./inflector";
import { toString } from "lodash";
import { useErrors } from "./use-errors";

export function useBind<
  Values = Record<string, unknown>,
  TransformValues extends _TransformValues<Values> = (values: Values) => Values
>(form: UseFormReturnType<Values, TransformValues>) {
  const [errorsFor] = useErrors();

  return function bind(
    path: LooseKeys<Values>,
    options?: Parameters<
      UseFormReturnType<Values, TransformValues>["getInputProps"]
    >[1]
  ) {
    const props = form.getInputProps(path, options);

    if ("value" in props && props.value === null) {
      props.value = "";
    }

    return {
      ...props,
      label: humanize(toString(path).split(".").pop()),
      error: errorsFor(path.toString()).error,
    };
  };
}

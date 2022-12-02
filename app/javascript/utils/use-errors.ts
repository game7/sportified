import { usePage } from "@inertiajs/inertia-react";
import { FormItemProps } from "antd";

// hook to provide an utility function that generates
// error props for form item by name
export function useErrors<T extends object>() {
  const { errors } = usePage().props;

  function errorsFor(attr: NestedKeyOf<T>): Partial<FormItemProps<T>> {
    // for associations we bind our forms to the _id attribute however
    // validation messages may come back for the association name, so
    // let's check for both.  For example - our model may belongs_to
    // widget via the attribute widget_id.  For our form we need to
    // bind to widget_id however validation messages could be returned
    // for widget
    const messages =
      errors &&
      (errors[attr as string] || errors[(attr as string).replace(/_id$/, "")]);

    if (messages) {
      return {
        validateStatus: "error",
        help: messages[0],
      };
    } else {
      return {};
    }
  }

  return [errorsFor];
}

import { usePage } from "@inertiajs/inertia-react";
import { LooseKeys } from "@mantine/form/lib/types";

// hook to provide an utility function that generates
// error props for form item by name
export function useErrors<T extends Record<string, unknown>>() {
  const { errors } = usePage().props;

  function errorsFor(path: LooseKeys<T>): { error?: string } {
    // for associations we bind our forms to the _id attribute however
    // validation messages may come back for the association name, so
    // let's check for both.  For example - our model may belongs_to
    // widget via the attribute widget_id.  For our form we need to
    // bind to widget_id however validation messages could be returned
    // for widget
    const messages =
      errors &&
      (errors[path as string] || errors[(path as string).replace(/_id$/, "")]);

    if (messages) {
      return {
        error: messages[0],
      };
    } else {
      return {};
    }
  }

  return [errorsFor];
}

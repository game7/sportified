import { Inertia } from "@inertiajs/inertia";
import { Button, ButtonProps } from "@mantine/core";
import type { PolymorphicComponentProps } from "@mantine/utils";

export function LinkButton(props: PolymorphicComponentProps<"a", ButtonProps>) {
  return (
    <Button
      component="a"
      {...props}
      onClick={(e) => {
        if (props.href) {
          e.preventDefault();
          Inertia.get(props.href);
        }
      }}
    />
  );
}

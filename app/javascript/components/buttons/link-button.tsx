import { Button, ButtonProps } from "@mantine/core";
import type { PolymorphicComponentProps } from "@mantine/utils";
import { withInertiaLink } from "~/utils/with-inertia-link";

function LinkButtonImpl(props: PolymorphicComponentProps<"a", ButtonProps>) {
  return <Button component="a" {...props} />;
}

export const LinkButton = withInertiaLink(LinkButtonImpl as any);

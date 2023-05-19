import { ActionIcon } from "@mantine/core";
import { IconZoomIn } from "@tabler/icons-react";
import { withInertiaLink } from "~/utils/with-inertia-link";

function ZoomLinkButtonImpl({
  href,
  onClick,
}: {
  href: string;
  onClick?: React.MouseEventHandler<HTMLAnchorElement>;
}) {
  return (
    <ActionIcon component="a" variant="default" href={href} onClick={onClick}>
      <IconZoomIn size="1rem" />
    </ActionIcon>
  );
}

export const ZoomLinkButton = withInertiaLink(ZoomLinkButtonImpl);

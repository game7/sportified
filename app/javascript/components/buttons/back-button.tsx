import { Button, ButtonProps } from "@mantine/core";

export type BackButtonProps = Omit<ButtonProps, "href">;

export function BackButton(props: BackButtonProps) {
  return (
    <Button
      {...props}
      variant="default"
      onClick={(e) => {
        e.preventDefault();
        history.back();
      }}
    >
      {props.children || "Back"}
    </Button>
  );
}

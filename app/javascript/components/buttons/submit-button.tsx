import { Button, ButtonProps } from "@mantine/core";

export function SubmitButton(props: ButtonProps) {
  return (
    <Button {...props} variant="filled" type="submit">
      {props.children || "Submit"}
    </Button>
  );
}

import { Button, ButtonProps } from "antd";

export type SubmitButtonProps = Omit<ButtonProps, "href" | "type" | "htmlType">;

export function SubmitButton(props: SubmitButtonProps) {
  return (
    <Button {...props} type="primary" htmlType="submit">
      {props.children || "Submit"}
    </Button>
  );
}

import { Button, ButtonProps } from "antd";

export type BackButtonProps = Omit<ButtonProps, "href">;

export function BackButton(props: BackButtonProps) {
  return (
    <Button
      {...props}
      onClick={(e) => {
        e.preventDefault();
        history.back();
      }}
    >
      {props.children || "Back"}
    </Button>
  );
}

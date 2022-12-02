import { BackButton, BackButtonProps } from "./back-button";

export type CancelButtonProps = BackButtonProps;

export function CancelButton(props: CancelButtonProps) {
  return <BackButton {...props}>{props.children || "Cancel"}</BackButton>;
}

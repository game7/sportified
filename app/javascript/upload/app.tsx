import { PropsWithChildren } from "react";

export default function App(props: PropsWithChildren) {
  return <div>{props.children}</div>;
}

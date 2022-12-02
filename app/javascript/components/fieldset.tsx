import { PropsWithChildren } from "react";

interface FieldsetProps extends PropsWithChildren {
  title?: string;
}

export function Fieldset({ title, children }: FieldsetProps) {
  return (
    <fieldset>
      {title && <legend>{title}</legend>}
      {children}
    </fieldset>
  );
}

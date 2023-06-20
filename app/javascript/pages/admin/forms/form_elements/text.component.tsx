import { TextInput } from "@mantine/core";
import { startCase } from "lodash";

interface Props {
  element: App.FormElement;
}

export function Text({ element }: Props) {
  return (
    <TextInput
      label={startCase(element.name!)}
      withAsterisk={!!element.required}
    />
  );
}

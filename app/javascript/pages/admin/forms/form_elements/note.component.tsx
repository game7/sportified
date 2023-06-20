import { Textarea } from "@mantine/core";
import { startCase } from "lodash";

interface Props {
  element: FormElements.Note;
}

export function Note({ element }: Props) {
  return (
    <Textarea
      label={startCase(element.name || "")}
      withAsterisk={!!element.required}
      description={element.hint}
      autosize
      minRows={element.rows || 3}
    />
  );
}

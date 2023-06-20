import { Checkbox, Group, Radio, Select, Stack } from "@mantine/core";
import { startCase } from "lodash";

interface Props {
  element: FormElements.Choice;
}

export function Choice({ element }: Props) {
  const options = element.options!.split("\r\n");

  if (element.allow_multiple) {
    return (
      <Checkbox.Group
        label={startCase(element.name!)}
        description={element.hint}
        withAsterisk={!!element.required}
      >
        <Stack spacing="xs" sx={{ gap: "0.375rem" }}>
          {options.map((option) => (
            <Checkbox key={option} value={option} label={option} />
          ))}
        </Stack>
      </Checkbox.Group>
    );
  }
  if (options.length <= 6) {
    return (
      <Radio.Group
        label={startCase(element.name!)}
        description={element.hint}
        withAsterisk={!!element.required}
      >
        <Stack spacing="xs" sx={{ gap: "0.375rem" }}>
          {options.map((option) => (
            <Radio key={option} value={option} label={option} />
          ))}
        </Stack>
      </Radio.Group>
    );
  }
  return (
    <Select
      label={startCase(element.name || "")}
      description={element.hint}
      data={options}
      required={!!element.required}
    />
  );
}

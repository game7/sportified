import { Checkbox, Group, Stack, TextInput, Textarea } from "@mantine/core";
import { useForm } from "@mantine/form";
import { pick } from "lodash";
import { SubmitButton } from "~/components/buttons";
import { actions } from "~/routes";
import { useBind } from "~/utils/use-bind";

interface Props {
  element: FormElements.Choice;
  onSuccess?: () => void;
}

export function ChoiceSettings(props: Props) {
  const { element, onSuccess } = props;

  const form = useForm({ initialValues: element });
  const bind = useBind(form);

  function handleSubmit(data: App.FormElement) {
    actions["next/admin/forms/form_elements/choices"]["update"].patch(
      { id: data.id },
      {
        form_element: pick(
          data,
          "name",
          "required",
          "options",
          "allow_multiple",
          "hint"
        ),
      },
      { preserveScroll: true, onSuccess }
    );
  }

  return (
    <form onSubmit={form.onSubmit(handleSubmit)}>
      <Stack>
        <TextInput {...bind("name")} withAsterisk />
        <Checkbox {...bind("required", { type: "checkbox" })} />
        <Textarea
          {...bind("options")}
          description="one option per line"
          autosize
          minRows={3}
          maxRows={10}
        />
        <Checkbox {...bind("allow_multiple", { type: "checkbox" })} />
        <TextInput {...bind("hint")} />
        <Group spacing="xs">
          <SubmitButton></SubmitButton>
        </Group>
      </Stack>
    </form>
  );
}

import { Checkbox, Group, Stack, TextInput, Textarea } from "@mantine/core";
import { useForm } from "@mantine/form";
import { pick } from "lodash";
import { SubmitButton } from "~/components/buttons";
import { actions } from "~/routes";
import { useBind } from "~/utils/use-bind";

interface Props {
  element: FormElements.Agreement;
  onSuccess?: () => void;
}

export function AgreementSettings(props: Props) {
  const { element, onSuccess } = props;

  const form = useForm({ initialValues: element });
  const bind = useBind(form);

  function handleSubmit(data: App.FormElement) {
    actions["next/admin/forms/form_elements/agreements"]["update"].patch(
      { id: data.id },
      {
        form_element: pick(data, "name", "required", "terms", "hint"),
      },
      { preserveScroll: true, onSuccess }
    );
  }

  return (
    <form onSubmit={form.onSubmit(handleSubmit)}>
      <Stack>
        <TextInput {...bind("name")} withAsterisk />
        <Checkbox {...bind("required", { type: "checkbox" })} />
        <Textarea {...bind("terms")} autosize minRows={3} maxRows={10} />
        <TextInput {...bind("hint")} />
        <Group spacing="xs">
          <SubmitButton></SubmitButton>
        </Group>
      </Stack>
    </form>
  );
}

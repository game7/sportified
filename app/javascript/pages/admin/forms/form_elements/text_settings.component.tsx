import { Checkbox, Group, Stack, TextInput } from "@mantine/core";
import { useForm } from "@mantine/form";
import { pick } from "lodash";
import { SubmitButton } from "~/components/buttons";
import { actions } from "~/routes";
import { useBind } from "~/utils/use-bind";

interface Props {
  element: FormElements.Text;
  onSuccess?: () => void;
}

export function TextSettings(props: Props) {
  const { element, onSuccess } = props;

  const form = useForm({ initialValues: element });
  const bind = useBind(form);

  function handleSubmit(data: App.FormElement) {
    actions["next/admin/forms/form_elements/texts"]["update"].patch(
      { id: data.id },
      { form_element: pick(data, "name", "required", "pattern", "message") },
      { preserveScroll: true, onSuccess }
    );
  }

  return (
    <form onSubmit={form.onSubmit(handleSubmit)}>
      <Stack>
        <TextInput {...bind("name")} withAsterisk />
        <Checkbox {...bind("required")} />
        <TextInput {...bind("pattern")} />
        <TextInput {...bind("message")} />
        <Group spacing="xs">
          <SubmitButton></SubmitButton>
        </Group>
      </Stack>
    </form>
  );
}

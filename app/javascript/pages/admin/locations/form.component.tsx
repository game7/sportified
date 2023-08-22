import { Inertia, Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { ColorInput, Group, TextInput } from "@mantine/core";
import { useForm } from "@mantine/form";
import { Space } from "antd";
import { BackButton, SubmitButton } from "~/components/buttons";
import { useBind } from "~/utils/use-bind";

type Location = App.Location & { color: string };

interface Props extends App.SharedProps {
  location: Location;
}

export function LocationForm() {
  const { props } = usePage<Page<Props>>();
  const form = useForm<Location>({ initialValues: props.location });
  const bind = useBind(form);

  function handleSubmit(data: Location) {
    if (props.location.id) {
      Inertia.patch(`/next/admin/locations/${props.location.id}`, {
        location: data,
      } as any);
    } else {
      Inertia.post("/next/admin/locations", { location: data } as any);
    }
  }

  return (
    <form onSubmit={form.onSubmit(handleSubmit)}>
      <Space direction="vertical" style={{ width: "100%" }}>
        <TextInput
          {...bind("name")}
          required
          sx={() => ({
            width: 400,
          })}
        />
        <TextInput
          {...bind("short_name")}
          required
          sx={() => ({
            width: 150,
          })}
        />
        <ColorInput
          {...bind("color")}
          sx={() => ({
            width: 150,
          })}
        />
        <Group spacing="xs">
          <SubmitButton></SubmitButton>
          <BackButton></BackButton>
        </Group>
      </Space>
    </form>
  );
}

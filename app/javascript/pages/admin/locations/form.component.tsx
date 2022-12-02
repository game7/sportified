import { Inertia, Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { Form, Input, Space } from "antd";
import { Colorpicker } from "antd-colorpicker";
import { ColorResult } from "react-color";
import { BackButton, SubmitButton } from "~/components/buttons";
import { asPayload, useForm } from "~/utils/use-form";

type Location = App.Location & { color: string };

type Mode = "create" | "update";

interface Props extends App.SharedProps {
  location: Location;
}

export function LocationForm() {
  const { props } = usePage<Page<Props>>();
  const { form, bind } = useForm<Location>(props.location);
  const mode: Mode = props.location.id ? "update" : "create";

  function handleFinish(data: Location) {
    if (props.location.id) {
      Inertia.patch(
        `/next/admin/locations/${props.location.id}`,
        asPayload({ location: data })
      );
    } else {
      Inertia.post("/next/admin/locations", asPayload({ location: data }));
    }
  }

  return (
    <Form form={form} onFinish={handleFinish} layout="vertical">
      <Space direction="vertical" style={{ width: "100%" }}>
        <Form.Item {...bind("name")} required>
          <Input />
        </Form.Item>
        <Form.Item {...bind("short_name")}>
          <Input />
        </Form.Item>
        <Form.Item
          {...bind("color")}
          getValueFromEvent={(event: ColorResult) => event.hex}
        >
          <Colorpicker picker="CompactPicker" />
        </Form.Item>
        <Form.Item>
          <Space>
            <SubmitButton></SubmitButton>
            <BackButton></BackButton>
          </Space>
        </Form.Item>
      </Space>
    </Form>
  );
}

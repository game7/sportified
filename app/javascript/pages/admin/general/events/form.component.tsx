import { Inertia, Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import {
  Card,
  Checkbox,
  Form,
  Input,
  InputNumber,
  Radio,
  Select,
  Space,
} from "antd";
import dayjs from "dayjs";
import { useEffect, useState } from "react";
import { BackButton, SubmitButton } from "~/components/buttons";
import DatePicker from "~/components/date-picker";
import { Fieldset } from "~/components/fieldset";
import { asPayload, useForm } from "~/utils/use-form";

type GeneralEvent = WithOptional<General.Event, "recurrence"> & {
  tag_list: string;
};

type Ending = "on" | "after";

type Mode = "create" | "update";

interface Props extends App.SharedProps {
  event: GeneralEvent;
  locations: App.Location[];
  tags: ActsAsTaggableOn.Tag[];
}

export function GeneralEventForm() {
  const { props } = usePage<Page<Props>>();
  const { locations, tags } = props;
  const { form, bind } = useForm<GeneralEvent>(props.event);
  const mode: Mode = props.event.id ? "update" : "create";

  const [repeat, setRepeat] = useState(false);
  const [ending, setEnding] = useState<Ending>();

  function handleEndingChanged(value: Ending) {
    setEnding(value);
  }

  useEffect(() => {
    if (repeat == false) {
      form.setFieldValue(["recurrence", "ending"], undefined);
      setEnding(undefined);
    }
  }, [repeat]);

  function handleFinish(data: GeneralEvent) {
    console.log(data);
    if (props.event.id) {
      Inertia.patch(
        `/next/admin/general/events/${props.event.id}`,
        asPayload({ general_event: data })
      );
    } else {
      Inertia.post(
        "/next/admin/general/events",
        asPayload({ general_event: data }, "recurrence")
      );
    }
  }

  return (
    <Form form={form} onFinish={handleFinish} layout="vertical">
      <Space direction="vertical" style={{ width: "100%" }}>
        <Fieldset title="Logistics">
          <Space>
            <Form.Item
              {...bind("starts_on")}
              initialValue={
                props.event.starts_on ? dayjs(props.event.starts_on) : null
              }
              required
            >
              <DatePicker showTime format="M/D/YYYY h:mm a" />
            </Form.Item>
            <Form.Item {...bind("duration")} required>
              <InputNumber min={0} />
            </Form.Item>
          </Space>
          <Form.Item {...bind("all_day")} label={false} valuePropName="checked">
            <Checkbox>All Day</Checkbox>
          </Form.Item>
          <Form.Item {...bind("location_id")} required>
            <Select
              options={locations.map((location) => ({
                value: location.id,
                label: location.name,
              }))}
              allowClear
              showSearch
              filterOption={(input, option) =>
                (option?.label ?? "")
                  .toLowerCase()
                  .includes(input.toLowerCase())
              }
              style={{ width: 400 }}
            />
          </Form.Item>
        </Fieldset>
        <Fieldset title="Description">
          <Form.Item {...bind("summary")} required>
            <Input />
          </Form.Item>
          <Form.Item {...bind("description")}>
            <Input.TextArea rows={3} />
          </Form.Item>

          <Form.Item {...bind("tag_list")}>
            <Select
              mode="tags"
              options={tags.map((tag) => ({
                text: tag.name,
                value: tag.name,
              }))}
            />
          </Form.Item>
          <Form.Item {...bind("private")} label={false} valuePropName="checked">
            <Checkbox>Private</Checkbox>
          </Form.Item>
        </Fieldset>

        {mode == "create" && (
          <Fieldset title="Recurrence">
            <Form.Item label={false}>
              <Checkbox onChange={(e) => setRepeat(e.target.checked)}>
                Repeat
              </Checkbox>
            </Form.Item>
            <Card style={{ display: repeat ? "block" : "none" }}>
              <Form.Item
                {...bind("recurrence.sunday")}
                label={false}
                valuePropName="checked"
              >
                <Checkbox>Repeat on Sunday</Checkbox>
              </Form.Item>
              <Form.Item
                {...bind("recurrence.monday")}
                label={false}
                valuePropName="checked"
              >
                <Checkbox>Repeat on Monday</Checkbox>
              </Form.Item>
              <Form.Item
                {...bind("recurrence.tuesday")}
                label={false}
                valuePropName="checked"
              >
                <Checkbox>Repeat on Tuesday</Checkbox>
              </Form.Item>
              <Form.Item
                {...bind("recurrence.wednesday")}
                label={false}
                valuePropName="checked"
              >
                <Checkbox>Repeat on Wednesday</Checkbox>
              </Form.Item>
              <Form.Item
                {...bind("recurrence.thursday")}
                label={false}
                valuePropName="checked"
              >
                <Checkbox>Repeat on Thursday</Checkbox>
              </Form.Item>
              <Form.Item
                {...bind("recurrence.friday")}
                label={false}
                valuePropName="checked"
              >
                <Checkbox>Repeat on Friday</Checkbox>
              </Form.Item>
              <Form.Item
                {...bind("recurrence.saturday")}
                label={false}
                valuePropName="checked"
              >
                <Checkbox>Repeat on Saturday</Checkbox>
              </Form.Item>
              <Form.Item {...bind("recurrence.ending")}>
                <Radio.Group
                  onChange={(e) => handleEndingChanged(e.target.value)}
                >
                  <Space direction="vertical">
                    <Radio value="on">On</Radio>
                    <Radio value="after">After</Radio>
                  </Space>
                </Radio.Group>
              </Form.Item>
              {ending == "on" && (
                <Form.Item {...bind("recurrence.ends_on")} label={false}>
                  <DatePicker />
                </Form.Item>
              )}
              {ending == "after" && (
                <Form.Item
                  {...bind("recurrence.occurrence_count")}
                  label={false}
                >
                  <InputNumber
                    min={1}
                    addonAfter="occurences"
                    style={{ width: 160 }}
                  />
                </Form.Item>
              )}
            </Card>
          </Fieldset>
        )}

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

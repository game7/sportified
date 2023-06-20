import { Inertia, Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import {
  Box,
  Checkbox,
  Divider,
  Group,
  MultiSelect,
  NumberInput,
  Radio,
  Stack,
  TextInput,
  Textarea,
} from "@mantine/core";
import { DatePicker } from "@mantine/dates";
import { useForm } from "@mantine/form";
import { toString } from "lodash";
import { Fragment, useState } from "react";
import { BackButton, SubmitButton } from "~/components/buttons";
import { Fieldset, NumberSelect } from "~/components/forms";
import { DateTimeInput } from "~/components/forms/date-time-input";
import { useBind } from "~/utils/use-bind";

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

  const form = useForm<GeneralEvent>({ initialValues: props.event });
  const bind = useBind(form);
  const mode: Mode = props.event.id ? "update" : "create";

  const [tagsData, setTagsData] = useState(
    tags.map((tag) => toString(tag.name))
  );

  const [repeat, setRepeat] = useState(false);

  function handleSubmit(data: GeneralEvent) {
    if (props.event.id) {
      Inertia.patch(`/next/admin/general/events/${props.event.id}`, {
        general_event: data,
      } as any);
    } else {
      Inertia.post("/next/admin/general/events", {
        general_event: data,
      } as any);
    }
  }

  return (
    <form onSubmit={form.onSubmit(handleSubmit)}>
      <Stack>
        <Fieldset title="Logistics">
          <Group sx={{ display: "flex", alignItems: "flex-start" }}>
            <DateTimeInput
              {...bind("starts_on")}
              dateInputProps={{ label: "Start Date", withAsterisk: true }}
              timeInputProps={{ label: "Start Time", withAsterisk: true }}
            />
            <NumberInput withAsterisk {...bind("duration")} maw={100} />
          </Group>
          <Checkbox {...bind("all_day")} />
          <NumberSelect
            withAsterisk
            {...bind("location_id")}
            data={locations.map((location) => ({
              value: location.id,
              label: toString(location.name),
            }))}
            maw={400}
          />
        </Fieldset>

        <Fieldset title="Description">
          <TextInput withAsterisk {...bind("summary")} />
          <Textarea {...bind("description")} />
          <MultiSelect
            {...bind("tag_list")}
            searchable
            clearable
            creatable
            getCreateLabel={(query) => `+ Create ${query}`}
            onCreate={(item) => {
              setTagsData((current) => [...current, item]);
              return item;
            }}
            data={tagsData}
          />
          <Checkbox {...bind("private")} />
        </Fieldset>

        {mode == "create" && (
          <Fieldset title="Recurrence">
            <Checkbox
              onChange={(e) => setRepeat(e.target.checked)}
              label="Repeat"
            />
            {repeat && (
              <Fragment>
                <Divider />
                <Checkbox {...bind("recurrence.monday")} />
                <Checkbox {...bind("recurrence.tuesday")} />
                <Checkbox {...bind("recurrence.wednesday")} />
                <Checkbox {...bind("recurrence.thursday")} />
                <Checkbox {...bind("recurrence.friday")} />
                <Checkbox {...bind("recurrence.saturday")} />
                <Checkbox {...bind("recurrence.sunday")} />
                <Divider />
              </Fragment>
            )}
            <Radio.Group {...bind("recurrence.ending")}>
              <Group mt="xs">
                <Radio value="on" label="On" />
                <Radio value="after" label="After" />
              </Group>
            </Radio.Group>

            {form.values.recurrence.ending == "on" && (
              <DatePicker {...bind("recurrence.ends_on")} miw={150} />
            )}

            {form.values.recurrence.ending == "after" && (
              <NumberInput
                withAsterisk
                {...bind("recurrence.occurrence_count", {})}
                rightSection={
                  <Box
                    sx={(theme) => ({
                      borderLeftColor: theme.colors.gray[4],
                      borderLeftWidth: 1,
                      borderLeftStyle: "solid",
                      width: 100,
                      height: "100%",
                      display: "flex",
                      justifyContent: "center",
                      alignItems: "center",
                    })}
                  >
                    occurrences
                  </Box>
                }
                rightSectionWidth={100}
                w={150}
              />
            )}
          </Fieldset>
        )}

        <Fieldset>
          <Group spacing="xs">
            <SubmitButton></SubmitButton>
            <BackButton></BackButton>
          </Group>
        </Fieldset>
      </Stack>
    </form>
  );
}

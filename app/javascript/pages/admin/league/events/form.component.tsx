import { Inertia, Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import {
  Checkbox,
  Grid,
  Group,
  NumberInput,
  Stack,
  TextInput,
  Textarea,
} from "@mantine/core";
import { useForm } from "@mantine/form";
import { BackButton, SubmitButton } from "~/components/buttons";
import { Fieldset, NumberSelect } from "~/components/forms";
import { DateTimeInput } from "~/components/forms/date-time-input";
import { useBind } from "~/utils/use-bind";

interface Option {
  id: number;
  name: string;
}

interface ProgramSpecificOption extends Option {
  program_id: number;
}

interface LocationSpecificOption extends Option {
  location_id: number;
}

interface Props extends App.SharedProps {
  event: League.Event;
  programs: Option[];
  seasons: ProgramSpecificOption[];
  divisions: ProgramSpecificOption[];
  locations: Option[];
  playing_surfaces: LocationSpecificOption[];
}

export function LeagueEventForm() {
  const { props } = usePage<Page<Props>>();
  const { event, programs, seasons, divisions, locations, playing_surfaces } =
    props;

  const form = useForm<League.Event>({ initialValues: props.event });
  const bind = useBind(form);

  function handleSubmit(data: League.Event) {
    if (event.id) {
      Inertia.patch(`/next/admin/league/events/${event.id}`, {
        event: data,
      } as any);
    } else {
      Inertia.post(`/next/admin/league/events`, { event: data } as any);
    }
  }

  return (
    <form onSubmit={form.onSubmit(handleSubmit)}>
      <Stack>
        <Fieldset title="Logistics">
          <Group sx={{ display: "flex", alignItems: "flex-start" }}>
            <NumberSelect
              withAsterisk
              {...bind("program_id")}
              data={programs.map((option) => ({
                label: option.name,
                value: option.id,
              }))}
              clearable
              maw={400}
            />
            <NumberSelect
              withAsterisk
              {...bind("season_id")}
              data={seasons
                .filter(
                  ({ program_id }) => program_id == form.values.program_id
                )
                .map((option) => ({
                  label: option.name,
                  value: option.id,
                }))}
              disabled={!form.values.program_id}
              maw={400}
            />
            <NumberSelect
              withAsterisk
              {...bind("division_id")}
              data={divisions
                .filter(
                  ({ program_id }) => program_id == form.values.program_id
                )
                .map((option) => ({
                  label: option.name,
                  value: option.id,
                }))}
              disabled={!form.values.program_id}
              miw={200}
            />
          </Group>

          <Group sx={{ display: "flex", alignItems: "flex-start" }}>
            <DateTimeInput
              {...bind("starts_on")}
              dateInputProps={{ label: "Start Date", withAsterisk: true }}
              timeInputProps={{ label: "Start Time", withAsterisk: true }}
            />
            <NumberInput withAsterisk {...bind("duration")} maw={100} />
          </Group>

          <Group sx={{ display: "flex", alignItems: "flex-start" }}>
            <NumberSelect
              withAsterisk
              {...bind("location_id")}
              data={locations.map((location) => ({
                value: location.id,
                label: location.name,
              }))}
            />
            <NumberSelect
              {...bind("playing_surface_id")}
              data={playing_surfaces
                .filter(
                  ({ location_id }) => location_id == form.values.location_id
                )
                .map((location) => ({
                  value: location.id,
                  label: location.name,
                }))}
              disabled={!form.values.location_id}
              clearable
              miw={200}
              maw={400}
            />
          </Group>
        </Fieldset>

        <Fieldset title="Description">
          <TextInput withAsterisk {...bind("summary")} />
          <Textarea {...bind("description")} rows={3} />
        </Fieldset>

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

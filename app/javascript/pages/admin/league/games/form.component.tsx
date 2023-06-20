import { Inertia, Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import {
  Checkbox,
  Grid,
  Group,
  NumberInput,
  Stack,
  TextInput,
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

interface SeasonDivisionSpecificOption extends Option {
  season_id: number;
  division_id: number;
}

interface LocationSpecificOption extends Option {
  location_id: number;
}

interface Props extends App.SharedProps {
  game: League.Game;
  programs: Option[];
  seasons: ProgramSpecificOption[];
  divisions: ProgramSpecificOption[];
  locations: Option[];
  playing_surfaces: LocationSpecificOption[];
  locker_rooms: LocationSpecificOption[];
  teams: SeasonDivisionSpecificOption[];
}

export function LeagueGameForm() {
  const { props } = usePage<Page<Props>>();
  const {
    game,
    programs,
    seasons,
    divisions,
    locations,
    playing_surfaces,
    locker_rooms,
    teams,
  } = props;

  const form = useForm<League.Game>({ initialValues: props.game });
  const bind = useBind(form);

  function handleSubmit(data: League.Game) {
    if (game.id) {
      Inertia.patch(`/next/admin/league/games/${game.id}`, {
        game: data,
      } as any);
    } else {
      Inertia.post(`/next/admin/league/games`, { game: data } as any);
    }
  }

  const teamOptions = teams
    .filter(
      (team) =>
        team.season_id == form.values.season_id &&
        team.division_id == form.values.division_id
    )
    .map((team) => ({
      label: team.name,
      value: team.id,
    }));

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

        <Grid>
          <Grid.Col span={6}>
            <Fieldset title="Away">
              <NumberSelect
                {...bind("away_team_id")}
                label="Team"
                data={teamOptions}
                searchable
                disabled={!(form.values.season_id && form.values.division_id)}
                clearable
              />
              <Checkbox
                {...bind("away_team_custom_name", { type: "checkbox" })}
                label="Custom Name"
              />
              {form.values.away_team_custom_name && (
                <TextInput {...bind("away_team_name")} label={false} />
              )}

              <NumberSelect
                {...bind("away_team_locker_room_id")}
                label="Locker Room"
                data={locker_rooms
                  .filter((room) => room.location_id == form.values.location_id)
                  .map((room) => ({ value: room.id, label: room.name }))}
                disabled={!form.values.location_id}
                clearable
              />
            </Fieldset>
          </Grid.Col>

          <Grid.Col span={6}>
            <Fieldset title="Home">
              <NumberSelect
                {...bind("home_team_id")}
                label="Team"
                data={teamOptions}
                searchable
                disabled={!(form.values.season_id && form.values.division_id)}
                clearable
              />
              <Checkbox
                {...bind("home_team_custom_name", { type: "checkbox" })}
                label="Custom Name"
              />
              {form.values.home_team_custom_name && (
                <TextInput {...bind("home_team_name")} label={false} />
              )}

              <NumberSelect
                {...bind("home_team_locker_room_id")}
                label="Locker Room"
                data={locker_rooms
                  .filter((room) => room.location_id == form.values.location_id)
                  .map((room) => ({ value: room.id, label: room.name }))}
                disabled={!form.values.location_id}
                clearable
              />
            </Fieldset>
          </Grid.Col>
        </Grid>

        <Fieldset title="Display">
          <Group>
            <TextInput {...bind("text_before")} miw={200} maw={400} />
            <TextInput {...bind("text_after")} miw={200} maw={400} />
          </Group>
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

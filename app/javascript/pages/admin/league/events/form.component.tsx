import { Inertia, Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { Form, Input, InputNumber, Select, Space } from "antd";
import dayjs from "dayjs";
import { useState } from "react";
import { BackButton, SubmitButton } from "~/components/buttons";
import DatePicker from "~/components/date-picker";
import { Fieldset } from "~/components/fieldset";
import { asPayload, useForm } from "~/utils/use-form";

interface Event {
  all_day: boolean;
  created_at: string;
  description: string;
  division_id: number;
  duration: number;
  ends_on: string;
  id: number;
  location_id: number;
  page_id: number;
  playing_surface_id: number;
  program_id: number;
  season_id: number;
  starts_on: string;
  summary: string;
  tenant_id: number;
  updated_at: string;
}

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
  event: Event;
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
  const { form, bind } = useForm<Event>(event);

  const [state, setState] = useState({
    programId: event.program_id,
    locationId: event.location_id,
    seasonId: event.season_id,
    divisionId: event.division_id,
  });

  function patchState(update: Partial<typeof state>) {
    setState((existing) => ({
      ...existing,
      ...update,
    }));
  }

  function handleFinish(data: Event) {
    if (event.id) {
      Inertia.patch(
        `/next/admin/league/events/${event.id}`,
        asPayload({ event: data })
      );
    } else {
      Inertia.post(`/next/admin/league/events`, asPayload({ event: data }));
    }
  }

  return (
    <Form form={form} onFinish={handleFinish} layout="vertical">
      <Space direction="vertical" style={{ width: "100%" }}>
        <Fieldset title="Logistics">
          <Space direction="vertical" style={{ width: "100%" }}>
            <Space>
              <Form.Item {...bind("program_id")} required>
                <Select
                  options={programs.map((option) => ({
                    label: option.name,
                    value: option.id,
                  }))}
                  onChange={(value) => patchState({ programId: value })}
                  style={{ minWidth: 200 }}
                />
              </Form.Item>
              <Form.Item {...bind("season_id")} required>
                <Select
                  options={seasons
                    .filter(({ program_id }) => program_id == state.programId)
                    .map((option) => ({
                      label: option.name,
                      value: option.id,
                    }))}
                  onChange={(value) => patchState({ seasonId: value })}
                  style={{ minWidth: 200 }}
                  disabled={!state.programId}
                />
              </Form.Item>
              <Form.Item {...bind("division_id")} required>
                <Select
                  options={divisions
                    .filter(({ program_id }) => program_id == state.programId)
                    .map((option) => ({
                      label: option.name,
                      value: option.id,
                    }))}
                  onChange={(value) => patchState({ divisionId: value })}
                  style={{ minWidth: 200 }}
                  disabled={!state.programId}
                />
              </Form.Item>
            </Space>

            <Space>
              <Form.Item
                {...bind("starts_on")}
                initialValue={event.starts_on && dayjs(event.starts_on)}
                required
              >
                <DatePicker
                  showTime
                  format="M/D/YYYY h:mm a"
                  style={{ minWidth: 200 }}
                />
              </Form.Item>
              <Form.Item {...bind("duration")} required>
                <InputNumber min={0} />
              </Form.Item>
            </Space>
          </Space>
          <Space>
            <Form.Item {...bind("location_id")} required>
              <Select
                options={locations.map((location) => ({
                  value: location.id,
                  label: location.name,
                }))}
                onChange={(value) => patchState({ locationId: value })}
                style={{ minWidth: 200 }}
              />
            </Form.Item>
            <Form.Item {...bind("playing_surface_id")}>
              <Select
                options={playing_surfaces
                  .filter(({ location_id }) => location_id == state.locationId)
                  .map((location) => ({
                    value: location.id,
                    label: location.name,
                  }))}
                allowClear
                style={{ minWidth: 200 }}
                disabled={!state.locationId}
              />
            </Form.Item>
          </Space>
        </Fieldset>
        <Fieldset title="Description">
          <Form.Item {...bind("summary")} required>
            <Input />
          </Form.Item>
          <Form.Item {...bind("description")}>
            <Input.TextArea rows={3} />
          </Form.Item>
        </Fieldset>

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

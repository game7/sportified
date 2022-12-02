import { Inertia, Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import {
  Checkbox,
  Col,
  Form,
  Input,
  InputNumber,
  Row,
  Select,
  Space,
} from "antd";
import dayjs from "dayjs";
import { useState } from "react";
import { BackButton, SubmitButton } from "~/components/buttons";
import DatePicker from "~/components/date-picker";
import { Fieldset } from "~/components/fieldset";
import { asPayload, useForm } from "~/utils/use-form";

interface Game {
  all_day: boolean;
  away_team_custom_name: boolean;
  away_team_id: number;
  away_team_locker_room_id: number;
  away_team_name: string;
  away_team_score: number;
  completion: string;
  created_at: string;
  description: string;
  division_id: number;
  duration: number;
  ends_on: string;
  exclude_from_team_records: boolean;
  home_team_custom_name: boolean;
  home_team_id: number;
  home_team_locker_room_id: null;
  home_team_name: string;
  home_team_score: number;
  id: number;
  location_id: number;
  page_id: number;
  playing_surface_id: number;
  private: boolean;
  program_id: number;
  result: string;
  season_id: number;
  starts_on: string;
  statsheet_id: number;
  statsheet_type: string;
  summary: string;
  tag_list: string[];
  tenant_id: number;
  text_after: string;
  text_before: string;
  updated_at: string;
}

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
  game: Game;
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
  const { form, bind } = useForm<Game>(game);

  const [state, setState] = useState({
    programId: game.program_id,
    locationId: game.location_id,
    seasonId: game.season_id,
    divisionId: game.division_id,
    awayTeamCustomName: game.away_team_custom_name,
    homeTeamCustomName: game.home_team_custom_name,
  });

  function patchState(update: Partial<typeof state>) {
    setState((existing) => ({
      ...existing,
      ...update,
    }));
  }

  function handleFinish(data: Game) {
    if (game.id) {
      Inertia.patch(
        `/next/admin/league/games/${game.id}`,
        asPayload({ game: data })
      );
    } else {
      Inertia.post(`/next/admin/league/games`, asPayload({ game: data }));
    }
  }

  const teamOptions = teams
    .filter(
      (team) =>
        team.season_id == state.seasonId && team.division_id == state.divisionId
    )
    .map((team) => ({
      label: team.name,
      value: team.id,
    }));

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
                initialValue={game.starts_on && dayjs(game.starts_on)}
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
        <Row gutter={[16, 16]}>
          <Col span={12}>
            <Fieldset title="Away Team">
              <Form.Item {...bind("away_team_id")}>
                <Select
                  options={teamOptions}
                  disabled={!(state.seasonId && state.divisionId)}
                  showSearch
                  filterOption={(input, option) =>
                    (option?.label ?? "")
                      .toLowerCase()
                      .includes(input.toLowerCase())
                  }
                />
              </Form.Item>
              <Form.Item
                {...bind("away_team_custom_name")}
                label={false}
                valuePropName="checked"
              >
                <Checkbox
                  onChange={(e) =>
                    patchState({ awayTeamCustomName: e.target.checked })
                  }
                >
                  Away Team Custom Name
                </Checkbox>
              </Form.Item>
              <Form.Item
                {...bind("away_team_name")}
                hidden={!state.awayTeamCustomName}
              >
                <Input />
              </Form.Item>
              <Form.Item {...bind("away_team_locker_room_id")}>
                <Select
                  options={locker_rooms
                    .filter((room) => room.location_id == state.locationId)
                    .map((room) => ({ value: room.id, label: room.name }))}
                  disabled={!state.locationId}
                ></Select>
              </Form.Item>
            </Fieldset>
          </Col>
          <Col span={12}>
            <Fieldset title="Home Team">
              <Form.Item {...bind("home_team_id")}>
                <Select
                  options={teamOptions}
                  disabled={!(state.seasonId && state.divisionId)}
                  showSearch
                  filterOption={(input, option) =>
                    (option?.label ?? "")
                      .toLowerCase()
                      .includes(input.toLowerCase())
                  }
                />
              </Form.Item>
              <Form.Item
                {...bind("home_team_custom_name")}
                label={false}
                valuePropName="checked"
              >
                <Checkbox
                  onChange={(e) =>
                    patchState({ homeTeamCustomName: e.target.checked })
                  }
                >
                  Home Team Custom Name
                </Checkbox>
              </Form.Item>
              <Form.Item
                {...bind("home_team_name")}
                hidden={!state.homeTeamCustomName}
              >
                <Input />
              </Form.Item>
              <Form.Item {...bind("home_team_locker_room_id")}>
                <Select
                  options={locker_rooms
                    .filter((room) => room.location_id == state.locationId)
                    .map((room) => ({ value: room.id, label: room.name }))}
                  disabled={!state.locationId}
                ></Select>
              </Form.Item>
            </Fieldset>
          </Col>
        </Row>

        <Fieldset title="Display">
          <Space>
            <Form.Item {...bind("text_before")}>
              <Input style={{ minWidth: 200 }} />
            </Form.Item>
            <Form.Item {...bind("text_after")}>
              <Input style={{ minWidth: 200 }} />
            </Form.Item>
          </Space>
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

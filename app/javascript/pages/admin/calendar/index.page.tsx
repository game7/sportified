import {
  ClockCircleOutlined,
  DownloadOutlined,
  PlusOutlined,
  TagsOutlined,
} from "@ant-design/icons";
import { faLocationPin } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Inertia, Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Badge, Button, Dropdown, Popover, Select, Space } from "antd";
import dayjs, { Dayjs } from "dayjs";
import _, { intersection, keyBy, times } from "lodash";
import { ComponentProps } from "react";
import { useSearchParams } from "react-router-dom";
import DatePicker from "~/components/date-picker";
import { AdminLayout } from "~/components/layout/admin-layout";
import { withRouter } from "~/utils/with-router";

type Event = WithOptional<App.Event, "tags">;
type Location = Pick<App.Location, "id" | "name" | "color">;

interface Props extends App.SharedProps {
  date: string;
  events: Event[];
  locations: Location[];
  tags: App.Tag[];
}

type PickerMode = ComponentProps<typeof DatePicker>["picker"];
type ViewMode = Extract<PickerMode, "month" | "date">;
type EventColorSource = "location" | "tag";

const KEYS = {
  LOCATION: "location",
  TAG: "tag",
};

const PICKER_FORMAT: Record<ViewMode, string> = {
  month: "MMMM YYYY",
  date: "ddd MMM D, YYYY",
};

export default withRouter(function AdminCalendarIndexPage() {
  const { props } = usePage<Page<Props>>();
  const { locations, tags } = props;
  const date = dayjs(props.date);

  const [searchParams, setSearchParams] = useSearchParams();

  const query = {
    locationId: searchParams.get(KEYS.LOCATION),
    tags: searchParams.getAll(KEYS.TAG),
  };

  const colorSource: EventColorSource = query.locationId ? "tag" : "location";

  const events = _(props.events)
    .filter((e) =>
      query.locationId ? e.location_id.toString() == query.locationId : true
    )
    .filter((e) => {
      if (query.tags.length === 0) {
        return true;
      }
      const tag_list = e.tags.map((t) => t.name);
      return intersection(tag_list, query.tags).length > 0;
    })
    .groupBy((event) => dayjs(event.starts_on).format("YYYY-MM-DD"))
    .value();

  const view = (searchParams.get("view") || "month") as ViewMode;

  function handleDateChange(date: Dayjs) {
    let url = new URL(window.location.toString());
    url.searchParams.set("date", date.format("YYYY-MM-DD"));
    Inertia.get(url.toString());
  }

  function handleViewChange(mode: ViewMode) {
    let url = new URL(window.location.toString());
    url.searchParams.set("view", mode);
    Inertia.get(url.toString());
  }

  function handleLocationChange(value: string) {
    setSearchParams((params) => {
      if (value) {
        params.set(KEYS.LOCATION, value);
      } else {
        params.delete(KEYS.LOCATION);
      }
      return params;
    });
  }

  function handleTagChange(values: string[]) {
    console.log(values);
    setSearchParams((params) => {
      params.delete(KEYS.TAG);
      (values || []).forEach((value) => {
        params.append(KEYS.TAG, value);
      });
      return params;
    });
  }

  function handleDownloadClick() {
    let url = new URL(window.location.toString());
    url.pathname = url.pathname + ".csv";
    window.location.href = url.toString();
  }

  return (
    <AdminLayout
      title="Calendar"
      pageHeader={false}
      breadcrumbs={[{ label: "Calendar", href: "/next/admin/calendar" }]}
      fluid
    >
      <Space direction="vertical" size="large" style={{ width: "100%" }}>
        <div style={{ display: "flex", justifyContent: "space-between" }}>
          <Space>
            <DatePicker
              key="date"
              picker={view}
              format={PICKER_FORMAT[view]}
              defaultValue={date}
              allowClear={false}
              onChange={(value) => value && handleDateChange(value)}
            />
            {/* <Radio.Group
            optionType="button"
            value={view}
            onChange={(e) => handleViewChange(e.target.value)}
            options={[
              { label: "Month", value: "month" },
              // { label: "Week", value: "week" },
              { label: "Day", value: "date" },
            ]}
          /> */}
            <Select
              options={locations.map((record) => ({
                value: record.id.toString(),
                label: record.name,
              }))}
              defaultValue={query.locationId}
              onChange={(value) => handleLocationChange(value)}
              style={{ minWidth: 200 }}
              placeholder="Filter By Location"
              allowClear={true}
            />
            <Select
              options={tags.map((record) => ({
                value: record.name,
                label: record.name,
              }))}
              defaultValue={query.tags}
              onChange={(value) => handleTagChange(value)}
              style={{ minWidth: 200 }}
              placeholder="Filter By Tag(s)"
              mode="tags"
              allowClear={true}
            />
          </Space>
          <Space>
            <Button icon={<DownloadOutlined />} onClick={handleDownloadClick}>
              Export
            </Button>
            <Dropdown
              menu={{
                items: [
                  {
                    key: "general",
                    type: "group",
                    label: "General",
                  },
                  {
                    key: "general-event",
                    label: (
                      <Link href="/next/admin/general/events/new">Event</Link>
                    ),
                  },
                  {
                    key: "divider",
                    type: "divider",
                  },
                  {
                    key: "league",
                    type: "group",
                    label: "League",
                  },
                  {
                    key: "league-game",
                    label: (
                      <Link href="/next/admin/league/games/new">Game</Link>
                    ),
                  },
                  {
                    key: "league-practice",
                    label: (
                      <Link href="/next/admin/league/practices/new">
                        Practice
                      </Link>
                    ),
                  },
                  {
                    key: "league-event",
                    label: (
                      <Link href="/next/admin/league/events/new">Event</Link>
                    ),
                  },
                ],
              }}
            >
              <Button icon={<PlusOutlined />}>Add</Button>
            </Dropdown>
          </Space>
        </div>

        {view == "month" && (
          <CalendarMonthView
            date={date}
            events={events}
            locations={locations}
            colorSource={colorSource}
          />
        )}
        {view == "date" && (
          <CalendarDayView
            date={date}
            events={events}
            locations={locations}
            colorSource={colorSource}
          />
        )}
      </Space>
    </AdminLayout>
  );
});

function getMonthCalendarWeeks(date: Dayjs): Dayjs[][] {
  let weekStart = date.startOf("month").startOf("week");
  const weeks: Dayjs[][] = [];
  while (weekStart.format("YYYYMM") <= date.format("YYYYMM")) {
    weeks.push(times(7, (weekday) => weekStart.add(weekday, "day")));
    weekStart = weekStart.add(7, "days");
  }
  return weeks;
}

interface CalendarViewProps {
  date: Dayjs;
  events: Record<string, Event[]>;
  locations: Location[];
  colorSource: EventColorSource;
}

function CalendarDayView({ date, events }: CalendarViewProps) {
  return (
    <div className="ant-table ant-table-bordered">
      <div className="ant-table-container">
        <div className="ant-table-content">
          <table style={{ tableLayout: "fixed" }}>
            <thead className="ant-table-thead">
              <tr>
                <th className="ant-table-cell">Sunday</th>
                <th className="ant-table-cell">Monday</th>
                <th className="ant-table-cell">Tuesday</th>
                <th className="ant-table-cell">Wednesday</th>
                <th className="ant-table-cell">Thursday</th>
                <th className="ant-table-cell">Friday</th>
                <th className="ant-table-cell">Saturday</th>
              </tr>
            </thead>
          </table>
        </div>
      </div>
    </div>
  );
}

function renderTime(event: App.Event) {
  return event.all_day
    ? "All Day"
    : dayjs(event.starts_on).format("h:mma").replace("m", "");
}

function getEditUrl(event: App.Event) {
  if (event.type == "League::Game") {
    return `/next/admin/league/games/${event.id}/edit`;
  }
  if (event.type == "League::Practice") {
    return `/next/admin/league/practices/${event.id}/edit`;
  }
  if (event.type == "League::Event") {
    return `/next/admin/league/events/${event.id}/edit`;
  }
  return `/next/admin/general/events/${event.id}/edit`;
}

function toHexColor(str: string) {
  var hash = 0;
  for (var i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + ((hash << 5) - hash);
  }
  var colour = "#";
  for (var i = 0; i < 3; i++) {
    var value = (hash >> (i * 8)) & 0xff;
    colour += ("00" + value.toString(16)).substr(-2);
  }
  return colour;
}

function CalendarMonthView({
  date,
  events,
  colorSource,
  ...props
}: CalendarViewProps) {
  const weeks = getMonthCalendarWeeks(date);
  const locations = keyBy(props.locations, "id");

  function getColor(event: Event) {
    return colorSource == "location"
      ? locations[event.location_id]?.color
      : toHexColor(event.tags[0]?.name || "random");
  }

  return (
    <div className="ant-table ant-table-bordered">
      <div className="ant-table-container">
        <div className="ant-table-content">
          <table style={{ tableLayout: "fixed" }}>
            <thead className="ant-table-thead">
              <tr>
                <th className="ant-table-cell">Sunday</th>
                <th className="ant-table-cell">Monday</th>
                <th className="ant-table-cell">Tuesday</th>
                <th className="ant-table-cell">Wednesday</th>
                <th className="ant-table-cell">Thursday</th>
                <th className="ant-table-cell">Friday</th>
                <th className="ant-table-cell">Saturday</th>
              </tr>
            </thead>
            <tbody className="ant-table-tbody">
              {weeks.map((week) => (
                <tr
                  key={week[0].format("YYYY-MM-DD")}
                  className="ant-table-row"
                  style={{ height: 150 }}
                >
                  {week.map((day) => (
                    <td
                      key={day.format("YYYY-MM-DD")}
                      className="ant-table-cell"
                      style={{
                        verticalAlign: "top",
                        width: "14.285%",
                      }}
                    >
                      <div
                        style={{
                          width: "auto",
                          overflowX: "hidden",
                          whiteSpace: "nowrap",
                        }}
                      >
                        <div
                          style={{
                            fontWeight:
                              date.month() == day.month() ? "bold" : "",
                          }}
                        >
                          {day.format("D")}
                        </div>
                        <ul
                          className="events"
                          style={{ listStyle: "none", margin: 0, padding: 0 }}
                        >
                          {(events[day.format("YYYY-MM-DD")] || [])
                            // .slice(0, 5)
                            .map((event) => (
                              <li key={event.id}>
                                <Badge
                                  color={getColor(event)}
                                  text={
                                    <Popover
                                      title={event.summary}
                                      placement="right"
                                      content={
                                        <Space direction="vertical">
                                          <Space>
                                            <ClockCircleOutlined />
                                            <span>
                                              {dayjs(event.starts_on).format(
                                                "dddd, MMMM D, YYYY h:mm A"
                                              )}
                                              {dayjs(event.ends_on).format(
                                                "-h:mm A"
                                              )}
                                            </span>
                                          </Space>
                                          <Space>
                                            <FontAwesomeIcon
                                              icon={faLocationPin}
                                            />
                                            <span>
                                              {
                                                locations[event.location_id]
                                                  ?.name
                                              }
                                            </span>
                                          </Space>
                                          {event.tags.length > 0 && (
                                            <Space>
                                              <TagsOutlined />
                                              <span>
                                                {event.tags
                                                  .map((tag) => tag.name)
                                                  .join(", ")}
                                              </span>
                                            </Space>
                                          )}
                                        </Space>
                                      }
                                    >
                                      <Space>
                                        <span>{renderTime(event)}</span>
                                        <span style={{ cursor: "pointer" }}>
                                          <span>{event.summary}</span>
                                        </span>
                                      </Space>
                                    </Popover>
                                  }
                                />
                              </li>
                            ))}
                        </ul>
                      </div>
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

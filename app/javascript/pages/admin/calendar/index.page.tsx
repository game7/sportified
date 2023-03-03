import { DownloadOutlined, PlusOutlined } from "@ant-design/icons";
import { Inertia, Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Button, Dropdown, Select, Space } from "antd";
import dayjs, { Dayjs } from "dayjs";
import _, { intersection, times } from "lodash";
import { ComponentProps } from "react";
import { useSearchParams } from "react-router-dom";
import { EventPopover } from "~/components/calendar/event-popover";
import { EventWithBadge } from "~/components/calendar/event-with-badge";
import DatePicker from "~/components/date-picker";
import { AdminLayout } from "~/components/layout/admin-layout";
import { withRouter } from "~/utils/with-router";
import "./index.css";

type Event = WithOptional<App.Event, "tags">;
type Location = Pick<App.Location, "id" | "name" | "color">;

interface Props extends App.SharedProps {
  date: string;
  events: Event[];
  locations: Location[];
  tags: ActsAsTaggableOn.Tag[];
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
      query.locationId ? e.location_id?.toString() == query.locationId : true
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

  // function handleViewChange(mode: ViewMode) {
  //   let url = new URL(window.location.toString());
  //   url.searchParams.set("view", mode);
  //   Inertia.get(url.toString());
  // }

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

function CalendarMonthView({
  date,
  events,
  colorSource,
  locations,
  ...props
}: CalendarViewProps) {
  const weeks = getMonthCalendarWeeks(date);

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
                              <EventPopover
                                key={event.id}
                                event={event}
                                locations={locations}
                              >
                                <li className="calendar-event">
                                  <EventWithBadge event={event} />
                                </li>
                              </EventPopover>
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

import { Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import {
  Button,
  Group,
  MultiSelect,
  Select,
  Stack,
  Table,
} from "@mantine/core";
import { MonthPickerInput } from "@mantine/dates";
import { IconCalendar, IconDownload } from "@tabler/icons-react";
import dayjs, { Dayjs } from "dayjs";
import _, { intersection, times, toString } from "lodash";
import { ComponentProps } from "react";
import { EventWithBadge } from "~/components/calendar/event-with-badge";
import { EventWithHoverCard } from "~/components/calendar/event-with-hover-card";
import DatePicker from "~/components/date-picker";
import { AdminLayout } from "~/components/layout/admin-layout";
import { paths } from "~/routes";
import { useSearchParams } from "~/utils/use-search-params";
import { AddEventDropdown } from "../add-event-dropdown";
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
  DATE: "date",
};

export default function AdminCalendarIndexPage() {
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
    searchParams.set(KEYS.DATE, date.format("YYYY-MM-DD"));
    setSearchParams(searchParams, { only: ["date", "events"] });
  }

  function handleLocationChange(value: string | null) {
    if (value) {
      searchParams.set(KEYS.LOCATION, value);
    } else {
      searchParams.delete(KEYS.LOCATION);
    }
    setSearchParams(searchParams);
  }

  function handleTagChange(values: string[]) {
    searchParams.delete(KEYS.TAG);
    (values || []).forEach((value) => {
      searchParams.append(KEYS.TAG, value);
    });
    setSearchParams(searchParams);
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
      breadcrumbs={[
        {
          label: "Calendar",
          href: paths["/next/admin/events/calendar"].path({}),
        },
      ]}
      fluid
    >
      <Stack>
        <div style={{ display: "flex", justifyContent: "space-between" }}>
          <Group spacing="xs">
            <MonthPickerInput
              icon={<IconCalendar size="1rem" stroke={1.5} />}
              value={date.toDate()}
              onChange={(value) => value && handleDateChange(dayjs(value))}
            />
            <Select
              data={locations.map((record) => ({
                value: toString(record.id),
                label: toString(record.name),
              }))}
              defaultValue={query.locationId}
              onChange={(value) => handleLocationChange(value)}
              style={{ minWidth: 200 }}
              placeholder="Filter By Location"
              clearable
            />
            <MultiSelect
              data={tags.map((record) => toString(record.name))}
              defaultValue={query.tags}
              onChange={(value) => handleTagChange(value)}
              style={{ minWidth: 200 }}
              placeholder="Filter By Tag(s)"
              clearable
              searchable
            />
          </Group>
          <Group spacing="xs">
            <Button
              variant="default"
              leftIcon={<IconDownload size="1rem" />}
              onClick={handleDownloadClick}
            >
              Export
            </Button>
            <AddEventDropdown />
          </Group>
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
      </Stack>
    </AdminLayout>
  );
}

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
    <Table withBorder withColumnBorders>
      <thead>
        <tr>
          <th>Sunday</th>
          <th>Monday</th>
          <th>Tuesday</th>
          <th>Wednesday</th>
          <th>Thursday</th>
          <th>Friday</th>
          <th>Saturday</th>
        </tr>
      </thead>
    </Table>
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
    <Table withBorder withColumnBorders style={{ width: 840 }}>
      <colgroup>
        <col width="120" />
        <col width="120" />
        <col width="120" />
        <col width="120" />
        <col width="120" />
        <col width="120" />
        <col width="120" />
      </colgroup>
      <thead className="ant-table-thead">
        <tr>
          <th>Sunday</th>
          <th>Monday</th>
          <th>Tuesday</th>
          <th>Wednesday</th>
          <th>Thursday</th>
          <th>Friday</th>
          <th>Saturday</th>
        </tr>
      </thead>
      <tbody>
        {weeks.map((week) => (
          <tr
            key={week[0].format("YYYY-MM-DD")}
            className="ant-table-row"
            style={{ height: 150 }}
          >
            {week.map((day) => (
              <td
                key={day.format("YYYY-MM-DD")}
                style={{
                  verticalAlign: "top",
                  width: "14.285%",
                  textOverflow: "ellipsis",
                  overflow: "hidden",
                  whiteSpace: "nowrap",
                }}
              >
                <div
                  style={{
                    fontWeight: date.month() == day.month() ? "bold" : "",
                  }}
                >
                  {day.format("D")}
                </div>
                <Stack spacing="xs" sx={{ width: 180 }}>
                  {(events[day.format("YYYY-MM-DD")] || [])
                    // .slice(0, 5)
                    .map((event) => (
                      <EventWithHoverCard
                        key={event.id}
                        event={event}
                        locations={locations}
                      >
                        <div>
                          <EventWithBadge event={event} />
                        </div>
                      </EventWithHoverCard>
                    ))}
                </Stack>
              </td>
            ))}
          </tr>
        ))}
      </tbody>
    </Table>
  );
}

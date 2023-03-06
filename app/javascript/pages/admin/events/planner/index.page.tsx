import { Radio, Space, Statistic } from "antd";
import dayjs, { Dayjs } from "dayjs";
import { groupBy } from "lodash";
import { useCallback, useEffect, useLayoutEffect } from "react";
import { ScrollRestoration, useSearchParams } from "react-router-dom";
import { EventPopover } from "~/components/calendar/event-popover";
import { EventWithBadge } from "~/components/calendar/event-with-badge";
import DatePicker from "~/components/date-picker";
import { AdminLayout } from "~/components/layout/admin-layout";
import { actions, paths } from "~/routes";
import { toHexColor } from "~/utils/to-hex-color";
import { useLocalStorage } from "~/utils/use-local-storage";
import { usePage } from "~/utils/use-page";
import { withRouter } from "~/utils/with-router";
import { AddEventDropdown } from "../add-event-dropdown";

type PlannerEvent = WithOptional<App.Event, "location" | "program" | "tags"> & {
  location_id: number;
};

interface Props {
  date: string;
  events: PlannerEvent[];
  locations: App.Location[];
  tags: ActsAsTaggableOn.Tag[];
}

function getMonthDays(date: Dayjs): Dayjs[] {
  let start = date.startOf("month");
  let end = date.endOf("month").date();
  let i = 0;
  const days: Dayjs[] = [];
  for (i = 0; i < end; i++) {
    days.push(start.add(i, "day"));
  }
  return days;
}

export default withRouter(function AdminPlannerIndexPage() {
  const { events, locations, tags, ...props } = usePage<Props>().props;
  const [searchParams, setSearchParams] = useSearchParams();
  const [expanded, setExpanded] = useLocalStorage<boolean>("planner-expanded");

  const date = dayjs(props.date);
  const dates = getMonthDays(dayjs(props.date));
  const eventsByDay = groupBy(events, (event) => dayjs(event.starts_on).date());

  const scrollTo = useCallback(function scrollToDate(value: Dayjs) {
    const anchor = value.format("YYYY-MM-DD");
    setTimeout(() => {
      document.getElementById(anchor)?.scrollIntoView();
      window.scrollBy(0, -70);
    }, 100);
  }, []);

  useEffect(() => {
    if (searchParams.has("date")) {
      scrollTo(dayjs(searchParams.get("date")));
    }
  }, []);

  function handleDateClick(date: Dayjs) {
    searchParams.set("date", date.format("YYYY-MM-DD"));
    setSearchParams(searchParams);
  }

  function handleDateChange(value: Dayjs | null) {
    if (value && value?.isSame(date, "month")) {
      searchParams.set("date", value?.format("YYYY-MM-DD"));
      setSearchParams(searchParams);
      scrollTo(value);
      return;
    }
    paths["/next/admin/events/planner"].get(
      {},
      { date: value?.format("YYYY-MM-DD") || "" },
      { preserveScroll: true }
    );
  }

  return (
    <AdminLayout
      title="Planner"
      breadcrumbs={[
        {
          label: "Planner",
          href: paths["/next/admin/events/planner"].path({}),
        },
      ]}
      extra={
        <>
          <DatePicker
            value={date}
            format="MMMM D, YYYY"
            onChange={handleDateChange}
            allowClear={false}
          />
          <Radio.Group
            optionType="button"
            buttonStyle="outline"
            value={!!expanded}
            options={[
              { label: "Compact", value: false },
              { label: "Expanded", value: true },
            ]}
            onChange={(e) => setExpanded(!!e.target.value ? true : null)}
          />
          <AddEventDropdown />
        </>
      }
    >
      <Space direction="vertical" style={{ display: "flex" }}>
        <div className="ant-table ant-table-bordered">
          <div className="ant-table-container">
            <div className="ant-table-content">
              <table style={{ tableLayout: "fixed" }}>
                <colgroup>
                  <col style={{ textAlign: "center", width: 120 }} />
                </colgroup>
                <thead className="ant-table-thead">
                  <tr>
                    <th
                      className="ant-table-cell"
                      style={{ textAlign: "center" }}
                    >
                      Date
                    </th>
                    {locations.map((location) => (
                      <th
                        key={location.id}
                        className="ant-table-cell"
                        style={{ textAlign: "center" }}
                      >
                        {location.short_name}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody className="ant-table-tbody">
                  {dates.map((d) => (
                    <DayRow
                      key={d.date()}
                      date={d}
                      events={eventsByDay[d.date()]}
                      locations={locations}
                      expand={expanded}
                      onDateClick={handleDateClick}
                    />
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </Space>
    </AdminLayout>
  );
});

function DayRow({
  date,
  events = [],
  locations,
  expand,

  onDateClick,
}: {
  date: Dayjs;
  events: PlannerEvent[];
  locations: App.Location[];
  expand?: boolean;
  onDateClick?: (date: Dayjs) => void;
}) {
  const eventsByLocation = groupBy(events, (event) => event.location_id);

  function handleDateClick(
    e: React.MouseEvent<HTMLAnchorElement, MouseEvent>,
    date: Dayjs
  ) {
    if (onDateClick) {
      e.preventDefault();
      onDateClick(date);
    }
  }

  let height = 200;
  let start: Dayjs;

  if (events.length) {
    start = dayjs(events[0].starts_on);
    const last = events[events.length - 1];
    const end = dayjs(last.starts_on).add(last.duration || 0, "minutes");
    height = end.diff(start, "minute") + 60;
  }

  return (
    <tr id={date.format("YYYY-MM-DD")}>
      <td
        className="ant-table-cell"
        style={{ textAlign: "center", verticalAlign: "top" }}
      >
        <div style={{ position: "sticky", top: 80 }}>
          <Statistic
            value={date.format("D")}
            title={date.format("dddd").toUpperCase()}
          />
        </div>
      </td>
      {expand && events.length
        ? locations.map((location) => (
            <ScaledEventCell
              key={location.id}
              events={eventsByLocation[location.id]}
              locations={locations}
              start={start}
              height={height}
            />
          ))
        : locations.map((location) => (
            <CompactEventCell
              key={location.id}
              events={eventsByLocation[location.id]}
              locations={locations}
            />
          ))}
    </tr>
  );
}

function CompactEventCell({
  events = [],
  locations,
}: {
  events: WithOptional<App.Event, "tags">[];
  locations: App.Location[];
}) {
  return (
    <td className="ant-table-cell" style={{ verticalAlign: "top" }}>
      {events.map((event) => (
        <div key={event.id}>
          <EventPopover event={event} locations={locations} placement="right">
            <div style={{ display: "inline-block", cursor: "pointer" }}>
              <EventWithBadge event={event} />
            </div>
          </EventPopover>
        </div>
      ))}
    </td>
  );
}

function ScaledEventCell({
  events = [],
  locations,
  start,
  height,
}: {
  events: WithOptional<App.Event, "tags">[];
  locations: App.Location[];
  start: Dayjs;
  height: number;
}) {
  return (
    <td className="ant-table-cell" style={{ verticalAlign: "top", height }}>
      {events.map((event) => (
        <ScaledEvent
          key={event.id}
          event={event}
          locations={locations}
          dayStart={start}
        />
      ))}
    </td>
  );
}

function ScaledEvent({
  event,
  locations,
  dayStart,
}: {
  event: WithOptional<App.Event, "tags">;
  locations: App.Location[];
  dayStart: Dayjs;
}) {
  const starts_on = dayjs(event.starts_on);
  const top = dayjs(event.starts_on).diff(dayStart, "minutes") + 20;

  const color = toHexColor(event.tags[0]?.name || "random");

  const renderTime = useCallback((event: App.Event) => {
    if (event.all_day) {
      return "All Day";
    }
    return `${starts_on.format("h:mm a")} - ${starts_on
      .add(event.duration || 0, "minute")
      .format("h:mm a")}`;
  }, []);

  return (
    <EventPopover event={event} locations={locations}>
      <div
        style={{
          borderStyle: "solid",
          borderWidth: 1,
          borderColor: color,
          backgroundColor: color + "33",
          position: "absolute",
          width: "90%",
          top,
          height: event.all_day ? 60 : event.duration || 20,
          marginTop: -1,
          marginBottom: -1,
          padding: 5,
          borderRadius: 2,
          cursor: "pointer",
        }}
      >
        <div>{renderTime(event)}</div>
        <div>{event.summary}</div>
      </div>
    </EventPopover>
  );
}

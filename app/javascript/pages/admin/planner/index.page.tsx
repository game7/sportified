import { HomeOutlined } from "@ant-design/icons";
import { Radio, Space, Statistic } from "antd";
import dayjs, { Dayjs } from "dayjs";
import { groupBy } from "lodash";
import { useSearchParams } from "react-router-dom";
import { LinkButton } from "~/components/buttons";
import { EventPopover } from "~/components/calendar/event-popover";
import { EventWithBadge } from "~/components/calendar/event-with-badge";
import { AdminLayout } from "~/components/layout/admin-layout";
import { paths } from "~/routes";
import { toHexColor } from "~/utils/to-hex-color";
import { useLocalStorage } from "~/utils/use-local-storage";
import { usePage } from "~/utils/use-page";
import { withRouter } from "~/utils/with-router";

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

  const dates = getMonthDays(dayjs(props.date));
  const eventsByDay = groupBy(events, (event) => dayjs(event.starts_on).date());

  function handleDateClick(date: Dayjs) {
    searchParams.set("date", date.format("YYYY-MM-DD"));
    setSearchParams(searchParams);
  }

  return (
    <AdminLayout
      title="Planner"
      breadcrumbs={[
        { label: "Planner", href: paths["/next/admin/planner"].path({}) },
      ]}
      extra={
        <>
          {" "}
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
  events,
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

  const start = dayjs(events[0].starts_on);
  const last = events[events.length - 1];
  const end = dayjs(last.starts_on).add(last.duration || 0, "minutes");
  const height = end.diff(start, "minute") + 60;

  return (
    <tr>
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
      {!expand &&
        locations.map((location) => (
          <CompactEventCell
            key={location.id}
            events={eventsByLocation[location.id]}
            locations={locations}
          />
        ))}
      {expand &&
        locations.map((location) => (
          <ScaledEventCell
            key={location.id}
            events={eventsByLocation[location.id]}
            locations={locations}
            start={start}
            height={height}
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
          height: event.duration || 20,
          marginTop: -1,
          marginBottom: -1,
          padding: 5,
          borderRadius: 2,
          cursor: "pointer",
        }}
      >
        <div>
          {starts_on.format("h:mm a")} -{" "}
          {starts_on.add(event.duration || 0, "minute").format("h:mm a")}
        </div>
        <div>{event.summary}</div>
      </div>
    </EventPopover>
  );
}

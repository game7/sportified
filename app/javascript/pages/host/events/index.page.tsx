import { Inertia, Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Space, Table } from "antd";
import dayjs from "dayjs";
import { chain, keyBy } from "lodash";
import DatePicker from "~/components/date-picker";
import { LinkButton } from "../../../components/buttons/link-button";
import { HostLayout } from "../../../components/layout/host-layout";

interface Props extends App.SharedProps {
  date: string;
  tenants: App.Tenant[];
  events: App.Event[];
}

function normalizeHour(hour: number) {
  let meridian = hour >= 12 ? "p" : "a";
  let normal = hour % 12;
  return `${normal == 0 ? 12 : normal}:00${meridian}`;
}

function timeFilterLabel(hh: string) {
  let numeric = parseInt(hh);
  return `${normalizeHour(numeric)} to ${normalizeHour(numeric + 1)}`;
}

export default function HostEventsIndexPage() {
  const { props } = usePage<Page<Props>>();
  const { events } = props;
  const tenants = keyBy(props.tenants, "id");
  const date = dayjs(props.date);

  return (
    <HostLayout
      title="Events"
      breadcrumbs={[{ href: "/host/events", label: "Events" }]}
      extra={[
        <DatePicker
          key="date"
          defaultValue={date}
          allowClear={false}
          disabledDate={(date) => date.isAfter(dayjs())}
          onChange={(value) => {
            if (value) {
              Inertia.get(`/host/events?date=${value.format("YYYY-MM-DD")}`);
            }
          }}
        />,
        <LinkButton key="clear-filters" href={window.location.pathname}>
          Clear Filters
        </LinkButton>,
      ]}
    >
      <Space direction="vertical" size="large" style={{ display: "flex" }}>
        <Table
          dataSource={events}
          rowKey={(exc) => exc.id}
          columns={[
            {
              dataIndex: "time",
              title: "Time",
              render: (time, event) => (
                <Link href={`/host/events/${event.id}`}>
                  {dayjs(time).format("h:mm:ss A Z")}
                </Link>
              ),
              width: "15%",
              filters: chain(events)
                .map((e) => dayjs(e.time).format("HH"))
                .uniq()
                .sort()
                .map((t) => ({
                  text: timeFilterLabel(t),
                  value: t,
                }))
                .value(),
              onFilter: (value, record) => {
                return dayjs(record.time).format("HH") === value;
              },
            },
            {
              dataIndex: "visit_id",
              title: "Visit",
              render: (id) => <Link href={`/host/visits/${id}`}>{id}</Link>,
              width: "10%",
            },
            {
              dataIndex: "name",
              title: "Name",
              width: "15%",
              filters: chain(events)
                .map((e) => e.name)
                .uniq()
                .sort()
                .map((name) => ({
                  text: name,
                  value: name,
                }))
                .value(),
              onFilter: (value, record) => {
                return record.name === value;
              },
            },
            {
              dataIndex: "tenant_id",
              title: "Tenant",
              render: (id) => tenants[id].name,
              width: "15%",
              ellipsis: true,
              filters: chain(events)
                .map((e) => e.tenant_id)
                .uniq()
                .map((id) => tenants[id])
                .sort((a, b) => a.name.localeCompare(b.name))
                .map((t) => ({
                  text: t.name,
                  value: t.id,
                }))
                .value(),
              onFilter: (value, record) => {
                return record.tenant_id === (value as number);
              },
            },
            // {
            //   dataIndex: ["properties", "params", "controller"],
            //   title: "Controller",
            //   filters: chain(events)
            //     .map((e) => e.properties.params?.controller)
            //     .uniq()
            //     .sort()
            //     .map((name) => ({ text: name, value: name }))
            //     .value(),
            //   onFilter: (value, record) => {
            //     return record.properties.params?.controller === value;
            //   },
            //   ellipsis: true,
            // },
            {
              dataIndex: ["properties", "params"],
              key: "controller-action",
              title: "Controller / Action",
              render: (params) => `${params.controller}#${params.action}`,
              filters: chain(events)
                .map(
                  (e) =>
                    `${e.properties.params.controller}#${e.properties.params.action}`
                )
                .uniq()
                .sort()
                .map((name) => ({ text: name, value: name }))
                .value(),
              onFilter: (value, record) => {
                console.log(value);
                return (
                  `${record.properties.params.controller}#${record.properties.params.action}` ===
                  value
                );
              },
              ellipsis: true,
            },
            {
              dataIndex: ["properties", "path"],
              title: "URL",
              // render: (time) => dayjs(time).format("h:mm:ss A Z"),
              ellipsis: true,
            },
            // {
            //   dataIndex: "tenant_id",
            //   title: "Tenant",
            //   render: (id) => tenants[id].name,
            //   ellipsis: true,
            // },
            // {
            //   dataIndex: "device_type",
            //   title: "Device",
            //   ellipsis: true,
            // },
            // {
            //   dataIndex: "os",
            //   title: "OS",
            //   ellipsis: true,
            // },
            // {
            //   dataIndex: "browser",
            //   title: "Browser",
            //   ellipsis: true,
            // },
          ]}
          bordered
        />
      </Space>
    </HostLayout>
  );
}

import { Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Collapse, Descriptions, DescriptionsProps, Space, Table } from "antd";
import dayjs from "dayjs";
import { HostLayout } from "../../../components/layout/host-layout";

interface Props extends App.SharedProps {
  visit: Ahoy.Visit;
  events: App.Event[];
}

export default function hostVisitsShowPage() {
  const { visit, events } = usePage<Page<Props>>().props;

  const { Item } = Descriptions;

  const COMMON_PROPS: DescriptionsProps = {
    bordered: true,
    column: 1,
    labelStyle: {
      width: "20%",
    },
    contentStyle: {
      width: "80%",
    },
  };

  return (
    <HostLayout
      title="Visit"
      breadcrumbs={[
        { href: "/host/visits", label: "Visits" },
        { href: `/host/visits/${visit.id}`, label: visit.id.toString() },
      ]}
    >
      <Space direction="vertical" size="large" style={{ display: "flex" }}>
        <Descriptions title="Basic Info" {...COMMON_PROPS}>
          <Item label="Started">{visit.started_at}</Item>
          <Item label="Tenant">{visit.tenant_id}</Item>
          <Item label="User">{visit.user_id}</Item>
          <Item label="IP">{visit.ip}</Item>
          <Item label="Device Type">{visit.device_type}</Item>
          <Item label="OS">{visit.browser}</Item>
          <Item label="Browser">{visit.browser}</Item>
          <Item label="User Agent">{visit.user_agent}</Item>
        </Descriptions>
        <Collapse>
          <Collapse.Panel header="All" key="1">
            <pre>{JSON.stringify(visit, null, 2)}</pre>
          </Collapse.Panel>
        </Collapse>
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
            },

            {
              dataIndex: "name",
              title: "Name",
              width: "15%",
            },

            {
              dataIndex: ["properties", "params"],
              key: "controller-action",
              title: "Controller / Action",
              render: (params) => `${params.controller}#${params.action}`,
              ellipsis: true,
            },
            {
              dataIndex: ["properties", "path"],
              title: "URL",
              ellipsis: true,
            },
          ]}
          bordered
        />
      </Space>
    </HostLayout>
  );
}

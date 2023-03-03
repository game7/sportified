import { Inertia, Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Space, Table } from "antd";
import dayjs from "dayjs";
import { keyBy } from "lodash";
import DatePicker from "~/components/date-picker";
import { LinkButton } from "../../../components/buttons/link-button";
import { HostLayout } from "../../../components/layout/host-layout";

interface Props extends App.SharedProps {
  date: string;

  tenants: App.Tenant[];
  visits: Ahoy.Visit[];
}

export default function HostVisitsIndexPage() {
  const { props } = usePage<Page<Props>>();
  const { visits } = props;
  const tenants = keyBy(props.tenants, "id");
  const date = dayjs(props.date);

  return (
    <HostLayout
      title="Visits"
      breadcrumbs={[{ href: "/host/visits", label: "Visits" }]}
      extra={[
        <DatePicker
          key="date"
          defaultValue={date}
          allowClear={false}
          onChange={(value) => {
            if (value) {
              Inertia.get(`/host/visits?date=${value.format("YYYY-MM-DD")}`);
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
          dataSource={visits}
          rowKey={(exc) => exc.id}
          columns={[
            {
              dataIndex: "id",
              title: "Id",
              render: (id) => <Link href={`/host/visits/${id}`}>{id}</Link>,
              width: "10%",
            },
            {
              dataIndex: "started_at",
              title: "Started At",
              render: (time) => dayjs(time).format("h:mm:ss A Z"),
              ellipsis: true,
            },
            {
              dataIndex: "tenant_id",
              title: "Tenant",
              render: (id) => tenants[id].name,
              ellipsis: true,
            },
            {
              dataIndex: "device_type",
              title: "Device",
              ellipsis: true,
            },
            {
              dataIndex: "os",
              title: "OS",
              ellipsis: true,
            },
            {
              dataIndex: "browser",
              title: "Browser",
              ellipsis: true,
            },
          ]}
          bordered
        />
      </Space>
    </HostLayout>
  );
}

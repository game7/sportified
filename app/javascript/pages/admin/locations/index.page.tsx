import { PlusOutlined, ZoomInOutlined } from "@ant-design/icons";
import { Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { Table } from "antd";
import { LinkButton } from "~/components/buttons";
import { AdminLayout } from "~/components/layout/admin-layout";

interface Props extends App.SharedProps {
  locations: App.Location[];
}

export default function AdminLocationsIndexPage() {
  const { props } = usePage<Page<Props>>();
  const { locations } = props;

  return (
    <AdminLayout
      title="Locations"
      breadcrumbs={[{ label: "Locations", href: "/next/admin/locations" }]}
      extra={[
        <LinkButton
          key="new"
          href="/next/admin/locations/new"
          icon={<PlusOutlined />}
        >
          Add New Location
        </LinkButton>,
      ]}
    >
      <Table
        dataSource={locations}
        rowKey="id"
        columns={[
          {
            dataIndex: "id",
            render: (id) => (
              <LinkButton
                href={`/next/admin/locations/${id}`}
                icon={<ZoomInOutlined rotate={90} />}
              />
            ),
            width: 40,
          },
          { dataIndex: "name", title: "Name" },
        ]}
        bordered
        pagination={false}
      ></Table>
    </AdminLayout>
  );
}

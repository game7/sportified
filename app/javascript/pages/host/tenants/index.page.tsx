import { ZoomInOutlined } from "@ant-design/icons";
import { Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { Table } from "antd";
import { LinkButton } from "../../../components/buttons/link-button";
import { HostLayout } from "../../../components/layout/host-layout";

interface Props extends App.SharedProps {
  tenants: App.Tenant[];
}

export default function hostTenantsIndexPage() {
  const { tenants } = usePage<Page<Props>>().props;

  return (
    <HostLayout
      title="Tenants"
      breadcrumbs={[{ href: "/host/tenants", label: "Tenants" }]}
    >
      <Table
        dataSource={tenants}
        rowKey={(record) => record.id}
        bordered
        columns={[
          {
            dataIndex: "id",
            width: 40,
            render: (id) => (
              <LinkButton
                href={`/host/tenants/${id}`}
                icon={<ZoomInOutlined />}
              />
            ),
          },
          { dataIndex: "name", title: "Name" },
          { dataIndex: "slug", title: "Slug" },
        ]}
      />
    </HostLayout>
  );
}

import { PlusOutlined, ZoomInOutlined } from "@ant-design/icons";
import { Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { Table } from "@mantine/core";
import { LinkButton, ZoomLinkButton } from "~/components/buttons";
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
      <Table withBorder withColumnBorders>
        <thead>
          <tr>
            <th></th>
            <th>Name</th>
          </tr>
        </thead>
        <tbody>
          {locations.map((location) => (
            <tr>
              <td width={40}>
                <ZoomLinkButton href={`/next/admin/locations/${location.id}`} />
              </td>
              <td>{location.name}</td>
            </tr>
          ))}
        </tbody>
      </Table>
    </AdminLayout>
  );
}

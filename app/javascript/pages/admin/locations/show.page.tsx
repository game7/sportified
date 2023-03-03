import { EditOutlined } from "@ant-design/icons";
import { Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { LinkButton } from "~/components/buttons";
import { AdminLayout } from "~/components/layout/admin-layout";

interface Props extends App.SharedProps {
  location: App.Location;
}

export default function AdminLocationShowPage() {
  const { props } = usePage<Page<Props>>();
  const { location } = props;

  return (
    <AdminLayout
      title={location.name || ""}
      breadcrumbs={[
        { href: "/next/admin/locations", label: "Locations" },
        {
          href: `/next/admin/locations/${location.id}`,
          label: location.name || "",
        },
      ]}
      extra={[
        <LinkButton
          key="edit"
          href={`/next/admin/locations/${location.id}/edit`}
          icon={<EditOutlined />}
        >
          Edit
        </LinkButton>,
      ]}
    ></AdminLayout>
  );
}

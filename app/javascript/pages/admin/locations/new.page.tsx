import { AdminLayout } from "~/components/layout/admin-layout";

export default function NewAdminLocationsIndexPage() {
  return (
    <AdminLayout
      title="New Location"
      breadcrumbs={[
        { href: "/next/admin/locations", label: "Locations" },
        { href: `/next/admin/locations/new`, label: "New" },
      ]}
    ></AdminLayout>
  );
}

import { Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { AdminLayout } from "~/components/layout/admin-layout";
import { LocationForm } from "./form.component";

interface Props extends App.SharedProps {
  location: App.Location;
}

export default function EditAdminLocationsIndexPage() {
  const { props } = usePage<Page<Props>>();
  const { location } = props;

  return (
    <AdminLayout
      title="Editing Location"
      breadcrumbs={[
        { href: "/next/admin/locations", label: "Locations" },
        { href: `/next/admin/locations/${location.id}`, label: "Edit" },
      ]}
    >
      <LocationForm />
    </AdminLayout>
  );
}

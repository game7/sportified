import { AdminLayout } from "~/components/layout/admin-layout";
import { LeagueEventForm } from "./form.component";

export default function NewNextAdminLeagueEventsPage() {
  return (
    <AdminLayout
      title="New Event"
      breadcrumbs={[
        { href: "", label: "Events" },
        { href: "", label: "New" },
      ]}
    >
      <LeagueEventForm />
    </AdminLayout>
  );
}

import { AdminLayout } from "~/components/layout/admin-layout";
import { LeagueEventForm } from "./form.component";

export default function EditNextAdminLeagueEventsPage() {
  return (
    <AdminLayout
      title="Editing Event"
      breadcrumbs={[
        { href: "", label: "Games" },
        { href: "", label: "Edit" },
      ]}
    >
      <LeagueEventForm />
    </AdminLayout>
  );
}

import { AdminLayout } from "~/components/layout/admin-layout";
import { GeneralEventForm } from "./form.component";

export default function EditNextAdminGeneralEventsPage() {
  return (
    <AdminLayout
      title="Editing Event"
      breadcrumbs={[
        { href: "", label: "Events" },
        { href: "", label: "Edit" },
      ]}
    >
      <GeneralEventForm />
    </AdminLayout>
  );
}

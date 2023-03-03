import { AdminLayout } from "~/components/layout/admin-layout";
import { GeneralEventForm } from "./form.component";

export default function NewNextAdminGeneralEventsPage() {
  return (
    <AdminLayout
      title="New General Event"
      breadcrumbs={[
        { href: "", label: "Events" },
        { href: "", label: "New" },
      ]}
    >
      <GeneralEventForm />
    </AdminLayout>
  );
}

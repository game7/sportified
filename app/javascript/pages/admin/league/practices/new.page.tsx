import { AdminLayout } from "~/components/layout/admin-layout";
import { LeaguePracticeForm } from "./form.component";

export default function NewNextAdminLeaguePracticesPage() {
  return (
    <AdminLayout
      title="New Practice"
      breadcrumbs={[
        { href: "", label: "Practices" },
        { href: "", label: "New" },
      ]}
    >
      <LeaguePracticeForm />
    </AdminLayout>
  );
}

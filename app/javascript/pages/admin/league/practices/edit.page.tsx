import { AdminLayout } from "~/components/layout/admin-layout";
import { LeaguePracticeForm } from "./form.component";

export default function EditNextAdminLeaguePracticesPage() {
  return (
    <AdminLayout
      title="Editing Practice"
      breadcrumbs={[
        { href: "", label: "Practices" },
        { href: "", label: "Edit" },
      ]}
    >
      <LeaguePracticeForm />
    </AdminLayout>
  );
}

import { AdminLayout } from "~/components/layout/admin-layout";
import { LeagueGameForm } from "./form.component";

export default function EditNextAdminLeagueGamesPage() {
  return (
    <AdminLayout
      title="Editing Game"
      breadcrumbs={[
        { href: "", label: "Games" },
        { href: "", label: "Edit" },
      ]}
    >
      <LeagueGameForm />
    </AdminLayout>
  );
}

import { AdminLayout } from "~/components/layout/admin-layout";
import { LeagueGameForm } from "./form.component";

export default function NewNextAdminLeagueGamesPage() {
  return (
    <AdminLayout
      title="New Game"
      breadcrumbs={[
        { href: "", label: "Games" },
        { href: "", label: "New" },
      ]}
    >
      <LeagueGameForm />
    </AdminLayout>
  );
}

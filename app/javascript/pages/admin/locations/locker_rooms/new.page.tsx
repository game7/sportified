import { AdminLayout } from "~/components/layout/admin-layout";
import { actions } from "~/routes";
import { usePage } from "~/utils/use-page";
import { AdminLocationsLockerRoomsForm } from "./form.component";

interface Props {
  locker_room: App.LockerRoom;
  location: App.Location;
}

export default function AdminLocationsLockerRoomsNewPage() {
  const { location } = usePage<Props>().props;

  return (
    <AdminLayout
      title="New Locker Room"
      breadcrumbs={[
        {
          label: "Locations",
          href: actions["next/admin/locations"]["index"].path({}),
        },

        {
          label: location.name || "",
          href: actions["next/admin/locations"]["show"].path({
            id: location.id,
          }),
        },
        {
          label: "Locker Rooms",
          href: actions["next/admin/locations"]["show"].path({
            id: location.id,
          }),
        },
        {
          label: "New",
          href: actions["next/admin/locations/locker_rooms"]["new"].path({
            location_id: location.id,
          }),
        },
      ]}
    >
      <AdminLocationsLockerRoomsForm />
    </AdminLayout>
  );
}

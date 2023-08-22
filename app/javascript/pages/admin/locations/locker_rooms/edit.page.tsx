import { AdminLayout } from "~/components/layout/admin-layout";
import { actions } from "~/routes";
import { usePage } from "~/utils/use-page";
import { AdminLocationsLockerRoomsForm } from "./form.component";

interface Props {
  locker_room: App.LockerRoom;
  location: App.Location;
}

export default function AdminLocationsLockerRoomsEditPage() {
  const { locker_room, location } = usePage<Props>().props;

  return (
    <AdminLayout
      title={`Editing ${locker_room.name}`}
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
          label: "Edit",
          href: actions["next/admin/locations/locker_rooms"]["edit"].path({
            id: locker_room.id,
          }),
        },
      ]}
    >
      <AdminLocationsLockerRoomsForm />
    </AdminLayout>
  );
}

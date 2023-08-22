import { Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { ActionIcon, Box, Menu, Stack, Table, Title } from "@mantine/core";
import {
  IconDotsVertical,
  IconEdit,
  IconPlus,
  IconTrash,
} from "@tabler/icons-react";
import { LinkButton } from "~/components/buttons";
import { AdminLayout } from "~/components/layout/admin-layout";
import { actions } from "~/routes";

interface Props extends App.SharedProps {
  location: App.Location;
  playing_surfaces: App.PlayingSurface[];
  locker_rooms: App.LockerRoom[];
}

export default function AdminLocationShowPage() {
  const { props } = usePage<Page<Props>>();
  const { location, playing_surfaces, locker_rooms } = props;

  return (
    <AdminLayout
      title={location.name || ""}
      breadcrumbs={[
        { href: "/next/admin/locations", label: "Locations" },
        {
          href: `/next/admin/locations/${location.id}`,
          label: location.name || "",
        },
      ]}
      extra={[
        <LinkButton
          key="edit"
          href={`/next/admin/locations/${location.id}/edit`}
          leftIcon={<IconEdit size="1rem" />}
        >
          Edit
        </LinkButton>,
      ]}
    >
      <Stack>
        <Box sx={() => ({ display: "flex", justifyContent: "space-between" })}>
          <Title order={3}>Locker Rooms</Title>
          <div>
            <LinkButton
              size="xs"
              leftIcon={<IconPlus size="1rem" />}
              href={actions["next/admin/locations/locker_rooms"]["new"].path({
                location_id: location.id,
              })}
            >
              New Locker Room
            </LinkButton>
          </div>
        </Box>

        <Table withBorder withColumnBorders>
          <thead>
            <tr>
              <th></th>
              <th>Name</th>
              <th>Auto-Assign</th>
            </tr>
          </thead>
          <tbody>
            {locker_rooms.map((lockerRoom) => (
              <tr key={lockerRoom.id}>
                <td width={40}>
                  <Menu
                    shadow="md"
                    width={120}
                    position="bottom-start"
                    offset={5}
                  >
                    <Menu.Target>
                      <ActionIcon component="a" variant="default">
                        <IconDotsVertical size="1rem" />
                      </ActionIcon>
                    </Menu.Target>
                    <Menu.Dropdown>
                      <Menu.Item
                        icon={<IconEdit size={14} />}
                        component="a"
                        href={actions["next/admin/locations/locker_rooms"][
                          "edit"
                        ].path({ id: lockerRoom.id })}
                      >
                        Edit
                      </Menu.Item>
                      <Menu.Item
                        icon={<IconTrash size={14} />}
                        onClick={() => {
                          actions["next/admin/locations/locker_rooms"][
                            "destroy"
                          ].delete(
                            { id: lockerRoom.id },
                            { preserveScroll: true }
                          );
                        }}
                      >
                        Delete
                      </Menu.Item>
                    </Menu.Dropdown>
                  </Menu>
                </td>
                <td>{lockerRoom.name}</td>
                <td>{lockerRoom.auto_assign}</td>
              </tr>
            ))}
          </tbody>
        </Table>
      </Stack>
    </AdminLayout>
  );
}

import { Inertia } from "@inertiajs/inertia";
import { Button, Menu } from "@mantine/core";
import { IconPlus } from "@tabler/icons-react";
import { actions } from "~/routes";

export function AddEventDropdown() {
  function withHref(href: string) {
    return {
      href,
      onClick: (event: React.MouseEvent<HTMLAnchorElement, MouseEvent>) => {
        event.preventDefault();
        Inertia.get(href);
      },
    };
  }

  return (
    <Menu width={150} position="bottom-end">
      <Menu.Target>
        <Button
          variant="default"
          leftIcon={<IconPlus size="1rem" stroke={1.5} />}
        >
          Add
        </Button>
      </Menu.Target>
      <Menu.Dropdown>
        <Menu.Label>General</Menu.Label>
        <Menu.Item
          component="a"
          icon={<IconPlus size="1rem" stroke={1.5} />}
          {...withHref(actions["next/admin/general/events"]["new"].path({}))}
        >
          Event
        </Menu.Item>
        <Menu.Divider />
        <Menu.Label>League</Menu.Label>
        <Menu.Item
          component="a"
          icon={<IconPlus size="1rem" stroke={1.5} />}
          {...withHref(actions["next/admin/league/games"]["new"].path({}))}
        >
          Game
        </Menu.Item>
        <Menu.Item
          component="a"
          icon={<IconPlus size="1rem" stroke={1.5} />}
          {...withHref(actions["next/admin/league/practices"]["new"].path({}))}
        >
          Practice
        </Menu.Item>
        <Menu.Item
          component="a"
          icon={<IconPlus size="1rem" stroke={1.5} />}
          {...withHref(actions["next/admin/league/events"]["new"].path({}))}
        >
          Event
        </Menu.Item>
      </Menu.Dropdown>
    </Menu>
  );
}

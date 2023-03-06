import { PlusOutlined } from "@ant-design/icons";
import { Link } from "@inertiajs/inertia-react";
import { Button, Dropdown } from "antd";
import { actions } from "~/routes";

export function AddEventDropdown() {
  return (
    <Dropdown
      menu={{
        items: [
          {
            key: "general",
            type: "group",
            label: "General",
          },
          {
            key: "general-event",
            label: (
              <Link href={actions["next/admin/general/events"]["new"].path({})}>
                Event
              </Link>
            ),
          },
          {
            key: "divider",
            type: "divider",
          },
          {
            key: "league",
            type: "group",
            label: "League",
          },
          {
            key: "league-game",
            label: (
              <Link href={actions["next/admin/league/games"]["new"].path({})}>
                Game
              </Link>
            ),
          },
          {
            key: "league-practice",
            label: (
              <Link
                href={actions["next/admin/league/practices"]["new"].path({})}
              >
                Practice
              </Link>
            ),
          },
          {
            key: "league-event",
            label: (
              <Link href={actions["next/admin/league/events"]["new"].path({})}>
                Event
              </Link>
            ),
          },
        ],
      }}
    >
      <Button icon={<PlusOutlined />}>Add</Button>
    </Dropdown>
  );
}

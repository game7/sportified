import {
  ClockCircleOutlined,
  CopyOutlined,
  EditOutlined,
  TagsOutlined,
} from "@ant-design/icons";
import { faLocationPin } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Popover, Space } from "antd";
import dayjs from "dayjs";
import { keyBy } from "lodash";
import { ComponentProps, PropsWithChildren } from "react";
import { LinkButton } from "../buttons";

interface EventPopoverProps extends PropsWithChildren {
  event: WithOptional<App.Event, "tags">;
  locations: Pick<App.Location, "id" | "name" | "color">[];
  placement?: ComponentProps<typeof Popover>["placement"];
}

export function EventPopover({
  event,
  placement = "top",
  children,
  ...props
}: EventPopoverProps) {
  const locations = keyBy(props.locations, (location) => location.id);

  return (
    <Popover
      title={event.summary}
      placement={placement}
      content={
        <Space direction="vertical">
          <Space>
            <ClockCircleOutlined />
            <span>
              {dayjs(event.starts_on).format("dddd, MMMM D, YYYY h:mm A")}
              {dayjs(event.ends_on).format("-h:mm A")}
            </span>
          </Space>
          <Space>
            <FontAwesomeIcon icon={faLocationPin} />
            <span>{locations[event.location_id || 0]?.name}</span>
          </Space>
          {event.tags.length > 0 && (
            <Space>
              <TagsOutlined />
              <span>{event.tags.map((tag) => tag.name).join(", ")}</span>
            </Space>
          )}
          <Space>
            <LinkButton
              size="small"
              href={getEditUrl(event)}
              icon={<EditOutlined />}
            >
              Edit
            </LinkButton>
            <LinkButton
              size="small"
              href={getCloneUrl(event)}
              icon={<CopyOutlined />}
            >
              Clone
            </LinkButton>
          </Space>
        </Space>
      }
    >
      {children}
    </Popover>
  );
}

function getEditUrl(event: App.Event) {
  if (event.type == "League::Game") {
    return `/next/admin/league/games/${event.id}/edit`;
  }
  if (event.type == "League::Practice") {
    return `/next/admin/league/practices/${event.id}/edit`;
  }
  if (event.type == "League::Event") {
    return `/next/admin/league/events/${event.id}/edit`;
  }
  return `/next/admin/general/events/${event.id}/edit`;
}

function getCloneUrl(event: App.Event) {
  if (event.type == "League::Game") {
    return `/next/admin/league/games/new?clone=${event.id}`;
  }
  if (event.type == "League::Practice") {
    return `/next/admin/league/practices/new?clone=${event.id}`;
  }
  if (event.type == "League::Event") {
    return `/next/admin/league/events/new?clone=${event.id}`;
  }
  return `/next/admin/general/events/new?clone=${event.id}`;
}

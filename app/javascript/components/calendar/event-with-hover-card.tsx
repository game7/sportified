import {
  Divider,
  Group,
  HoverCard,
  List,
  Stack,
  ThemeIcon,
  Title,
} from "@mantine/core";
import {
  IconClock,
  IconCopy,
  IconEdit,
  IconMapPin,
  IconTags,
} from "@tabler/icons-react";
import dayjs from "dayjs";
import { PropsWithChildren } from "react";
import { LinkButton } from "../buttons";

type EventWithTags = WithOptional<App.Event, "tags">;

type EventHoverCardProps = PropsWithChildren<{
  event: EventWithTags;
  locations: Pick<App.Location, "id" | "name" | "color">[];
}>;

export function EventWithHoverCard({
  event,
  locations,
  children,
}: EventHoverCardProps) {
  const location = locations.find(
    (location) => location.id == event.location_id
  );

  return (
    <HoverCard shadow="xl" openDelay={500}>
      <HoverCard.Target>{children}</HoverCard.Target>
      <HoverCard.Dropdown>
        <Stack>
          <Title order={4} sx={{ backgroundColor: "#f5f5f5", padding: 10 }}>
            {event.summary}
          </Title>
          <List size="sm">
            <List.Item
              icon={
                <ThemeIcon radius="xl" size={24}>
                  <IconClock />
                </ThemeIcon>
              }
            >
              {dayjs(event.starts_on).format("h:mm A")}
              {" - "}
              {dayjs(event.ends_on).format("h:mm A")}
            </List.Item>
            <List.Item
              icon={
                <ThemeIcon radius="xl" size={24}>
                  <IconMapPin />
                </ThemeIcon>
              }
            >
              {location?.name}
            </List.Item>
            <List.Item
              icon={
                <ThemeIcon radius="xl" size={24}>
                  <IconTags />
                </ThemeIcon>
              }
            >
              {event.tags.map((tag) => tag.name).join(", ")}
            </List.Item>
          </List>
          <Divider />
          <Group spacing="xs">
            <LinkButton
              size="xs"
              variant="default"
              href={getEditUrl(event)}
              leftIcon={<IconEdit />}
            >
              Edit
            </LinkButton>
            <LinkButton
              size="xs"
              variant="default"
              href={getCloneUrl(event)}
              leftIcon={<IconCopy />}
            >
              Clone
            </LinkButton>
          </Group>
        </Stack>
      </HoverCard.Dropdown>
    </HoverCard>
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

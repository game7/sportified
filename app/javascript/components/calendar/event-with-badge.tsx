import { Badge } from "@mantine/core";
import dayjs from "dayjs";

type EventWithTags = WithOptional<App.Event, "tags">;

interface EventWithBadgeProps {
  event: EventWithTags;
}

export function EventWithBadge(props: EventWithBadgeProps) {
  const { event } = props;

  return (
    <Badge
      radius="sm"
      fullWidth
      sx={{
        justifyContent: "left",
        paddingLeft: 3,
        cursor: "pointer",
      }}
      leftSection={<span>{renderTime(event)}</span>}
      // ref={ref}
    >
      {event.summary}
    </Badge>
  );
}

function renderTime(event: App.Event) {
  return event.all_day
    ? "All Day"
    : dayjs(event.starts_on).format("h:mma").replace("m", "");
}

// function getColor(event: EventWithTags) {
//   return toHexColor(event.tags[0]?.name || "random");
// }

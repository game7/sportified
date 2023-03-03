import { Badge, Space } from "antd";
import dayjs from "dayjs";
import { toHexColor } from "~/utils/to-hex-color";

type EventWithTags = WithOptional<App.Event, "tags">;

interface EventWithBadgeProps {
  event: EventWithTags;
}

export function EventWithBadge({ event }: EventWithBadgeProps) {
  return (
    <Badge
      color={getColor(event)}
      text={
        <Space>
          <span>{renderTime(event)}</span>
          <span>{event.summary}</span>
        </Space>
      }
    />
  );
}

function renderTime(event: App.Event) {
  return event.all_day
    ? "All Day"
    : dayjs(event.starts_on).format("h:mma").replace("m", "");
}

function getColor(event: EventWithTags) {
  return toHexColor(event.tags[0]?.name || "random");
}

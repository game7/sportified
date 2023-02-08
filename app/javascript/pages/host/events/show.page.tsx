import { Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Descriptions, DescriptionsProps, List, Space } from "antd";
import { HostLayout } from "../../../components/layout/host-layout";

interface Props extends App.SharedProps {
  event: App.Event;
}

export default function hostEventsShowPage() {
  const { event } = usePage<Page<Props>>().props;

  const { Item } = Descriptions;
  console.log(event);
  const COMMON_PROPS: DescriptionsProps = {
    bordered: true,
    column: 1,
    labelStyle: {
      width: "20%",
    },
    contentStyle: {
      width: "80%",
    },
  };
  return (
    <HostLayout
      title="Event"
      breadcrumbs={[
        { href: "/host/events", label: "Events" },
        { href: `/host/events/${event.id}`, label: event.id.toString() },
      ]}
    >
      <Space direction="vertical" size="large" style={{ display: "flex" }}>
        <Descriptions title="Basic Info" {...COMMON_PROPS}>
          <Item label="Name">{event.name}</Item>
          {event.properties?.message && (
            <Item label="Message">{event.properties.message}</Item>
          )}
          <Item label="Time">{event.time}</Item>
          <Item label="Visit">
            <Link href={`/host/visits/${event.visit_id}`}>
              {event.visit_id}
            </Link>
          </Item>
          <Item label="User">{event.user_id}</Item>
          <Item label="Tenant">{event.tenant_id}</Item>
        </Descriptions>
        <Descriptions title="Properties" {...COMMON_PROPS}>
          <Item label="Host">{event.properties.host}</Item>
          <Item label="Path">{event.properties.path}</Item>
          <Item label="URL">{event.properties.url}</Item>
        </Descriptions>
        <Descriptions title="Params" {...COMMON_PROPS}>
          {Object.entries(event.properties.params).map(([key, value]) => (
            <Item label={key}>{value.toString()}</Item>
          ))}
        </Descriptions>
        <List
          header={<div>Backtrace</div>}
          bordered
          dataSource={event.properties.backtrace}
          renderItem={(item) => <List.Item>{item}</List.Item>}
        ></List>
      </Space>
    </HostLayout>
  );
}

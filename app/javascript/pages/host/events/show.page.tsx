import { Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Stack, Table, Title } from "@mantine/core";
import { Fragment } from "react";
import { PropertyTable } from "~/components/tables";
import { HostLayout } from "../../../components/layout/host-layout";

const { Item } = PropertyTable;

interface Props extends App.SharedProps {
  event: Ahoy.Event;
}

export default function hostEventsShowPage() {
  const { event } = usePage<Page<Props>>().props;

  return (
    <HostLayout
      title="Event"
      breadcrumbs={[
        { href: "/host/events", label: "Events" },
        { href: `/host/events/${event.id}`, label: event.id.toString() },
      ]}
    >
      <Stack>
        <Title order={4}>Basic Info</Title>

        <PropertyTable>
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
        </PropertyTable>

        <Title order={4}>Properties</Title>

        <PropertyTable>
          <Item label="Host">{event.properties?.host}</Item>
          <Item label="Path">{event.properties?.path}</Item>
          <Item label="URL">{event.properties?.url}</Item>
        </PropertyTable>

        <Title order={4}>Params</Title>

        <PropertyTable>
          {Object.entries(event.properties?.params).map(([key, value]) => (
            <Item key={key} label={key}>
              {value?.toString()}
            </Item>
          ))}
        </PropertyTable>

        {event.properties?.backtrace && (
          <Fragment>
            <Title order={4}>Backtrace</Title>

            <Table withBorder withColumnBorders>
              <tbody>
                {event.properties?.backtrace.map((item: string) => (
                  <tr key={item}>
                    <td>{item}</td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </Fragment>
        )}
      </Stack>
    </HostLayout>
  );
}

import { Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Accordion, Stack, Title, createStyles, rem } from "@mantine/core";
import dayjs from "dayjs";
import { DataGrid } from "mantine-data-grid";
import { PropertyTable } from "~/components/tables";
import { HostLayout } from "../../../components/layout/host-layout";

interface Props extends App.SharedProps {
  visit: Ahoy.Visit;
  events: Ahoy.Event[];
}

const { Item } = PropertyTable;

const useStyles = createStyles((theme) => ({
  item: {
    border: `${rem(1)} solid ${
      theme.colorScheme === "dark" ? theme.colors.dark[4] : theme.colors.gray[3]
    }`,
  },
}));

export default function hostVisitsShowPage() {
  const { visit, events } = usePage<Page<Props>>().props;

  const { classes } = useStyles();

  return (
    <HostLayout
      title="Visit"
      breadcrumbs={[
        { href: "/host/visits", label: "Visits" },
        { href: `/host/visits/${visit.id}`, label: visit.id.toString() },
      ]}
    >
      <Stack>
        <Title order={4}>Basic Info</Title>

        <PropertyTable>
          <Item label="Started">{visit.started_at}</Item>
          <Item label="Tenant">{visit.tenant_id}</Item>
          <Item label="User">{visit.user_id}</Item>
          <Item label="IP">{visit.ip}</Item>
          <Item label="Device Type">{visit.device_type}</Item>
          <Item label="OS">{visit.browser}</Item>
          <Item label="Browser">{visit.browser}</Item>
          <Item label="User Agent">{visit.user_agent}</Item>
        </PropertyTable>

        <Accordion>
          <Accordion.Item className={classes.item} value="All Parameters">
            <Accordion.Control>All Properties</Accordion.Control>
            <Accordion.Panel>
              <pre>{JSON.stringify(visit, null, 2)}</pre>
            </Accordion.Panel>
          </Accordion.Item>
        </Accordion>

        <Title order={4}>Events</Title>

        <DataGrid
          styles={(theme) => ({
            thead: {
              "::after": {
                backgroundColor: "transparent",
              },
            },
          })}
          withBorder
          withColumnBorders
          data={events}
          columns={[
            {
              header: "Time",
              cell: (cell) => (
                <Link href={`/host/events/${cell.row.original.id}`}>
                  {dayjs(cell.getValue<Date>()).format("h:mm:ss A Z")}
                </Link>
              ),
            },
            { accessorKey: "name", header: "Name" },
            {
              header: "Controller / Action",
              accessorFn: (event) =>
                `${event.properties?.params.controller}#${event.properties?.params.action}`,
            },
            {
              header: "URL",
              accessorFn: (event) => event.properties?.path,
            },
          ]}
        />
      </Stack>
    </HostLayout>
  );
}

import { Inertia, Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import dayjs from "dayjs";
import { keyBy } from "lodash";
import { DataGrid } from "mantine-data-grid";
import DatePicker from "~/components/date-picker";
import { LinkButton } from "../../../components/buttons/link-button";
import { HostLayout } from "../../../components/layout/host-layout";
import { Group, Stack } from "@mantine/core";
import { DatePickerInput } from "@mantine/dates";
import { IconCalendar } from "@tabler/icons-react";

interface Props extends App.SharedProps {
  date: string;

  tenants: App.Tenant[];
  visits: Ahoy.Visit[];
}

export default function HostVisitsIndexPage() {
  const { props } = usePage<Page<Props>>();
  const { visits } = props;
  const tenants = keyBy(props.tenants, "id");
  const date = dayjs(props.date);

  return (
    <HostLayout
      title="Visits"
      breadcrumbs={[{ href: "/host/visits", label: "Visits" }]}
      extra={[
        <DatePicker
          key="date"
          defaultValue={date}
          allowClear={false}
          onChange={(value) => {
            if (value) {
              Inertia.get(`/host/visits?date=${value.format("YYYY-MM-DD")}`);
            }
          }}
        />,
        <LinkButton key="clear-filters" href={window.location.pathname}>
          Clear Filters
        </LinkButton>,
      ]}
    >
      <Stack>
        <Group>
          <DatePickerInput
            icon={<IconCalendar size="1.1rem" stroke={1.5} />}
            value={date.toDate()}
            maxDate={dayjs().toDate()}
            onChange={(date) => {
              if (date) {
                Inertia.get(
                  `/host/events?date=${dayjs(date).format("YYYY-MM-DD")}`
                );
              }
            }}
          />
          <LinkButton href={window.location.pathname}>Clear Filters</LinkButton>
        </Group>
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
          data={visits}
          columns={[
            {
              accessorKey: "id",
              cell: (cell) => (
                <Link href={`/host/visits/${cell.getValue()}`}>
                  {cell.getValue<number>()}
                </Link>
              ),
              header: "Id",
            },
            {
              accessorKey: "started_at",
              accessorFn: (visit) =>
                dayjs(visit.started_at).format("h:mm:ss A Z"),
              header: "Started At",
            },
            {
              accessorKey: "tenant_id",
              accessorFn: (visit) => tenants[visit.tenant_id || ""].name,
              header: "Tenant",
            },
            {
              accessorKey: "device",
              header: "Device",
            },
            {
              accessorKey: "os",
              header: "OS",
            },
            {
              accessorKey: "browser",
              header: "Browser",
            },
          ]}
        ></DataGrid>
      </Stack>
    </HostLayout>
  );
}

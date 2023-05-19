import { Inertia, Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Group, MultiSelect, Stack } from "@mantine/core";
import { DatePickerInput } from "@mantine/dates";
import { IconCalendar } from "@tabler/icons-react";
import dayjs from "dayjs";
import { keyBy } from "lodash";
import { DataGrid, createOperatorFilter } from "mantine-data-grid";
import DatePicker from "~/components/date-picker";
import { LinkButton } from "../../../components/buttons/link-button";
import { HostLayout } from "../../../components/layout/host-layout";

interface Props extends App.SharedProps {
  date: string;
  tenants: App.Tenant[];
  events: Ahoy.Event[];
}

function normalizeHour(hour: number) {
  let meridian = hour >= 12 ? "p" : "a";
  let normal = hour % 12;
  return `${normal == 0 ? 12 : normal}:00${meridian}`;
}

// function timeFilterLabel(hh: string) {
//   let numeric = parseInt(hh);
//   return `${normalizeHour(numeric)} to ${normalizeHour(numeric + 1)}`;
// }

export default function HostEventsIndexPage() {
  const { props } = usePage<Page<Props>>();
  const { events } = props;
  const tenants = keyBy(props.tenants, "id");
  const date = dayjs(props.date);

  const tenantFilter = createOperatorFilter<string, string[]>({
    init: () => [],
    operators: [
      {
        op: "select",
        filterFn: (rowValue, filterValue) => filterValue.includes(rowValue),
        element: ({ onChange, value, ...rest }) => (
          <MultiSelect
            {...rest}
            data={props.tenants.map((tenant) => ({
              value: tenant.name || "",
              label: tenant.name || "",
            }))}
            value={value}
            onChange={onChange}
          />
        ),
      },
    ],
  });

  return (
    <HostLayout
      title="Events"
      breadcrumbs={[{ href: "/host/events", label: "Events" }]}
      extra={[
        <DatePicker
          key="date"
          defaultValue={date}
          allowClear={false}
          disabledDate={(date) => date.isAfter(dayjs())}
          onChange={(value) => {
            if (value) {
              Inertia.get(`/host/events?date=${value.format("YYYY-MM-DD")}`);
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
          withColumnFilters
          withSorting
          withPagination
          data={events}
          columns={[
            {
              accessorKey: "time",
              header: "Time",
              cell: (cell) => (
                <Link href={`/host/events/${cell.row.original.id}`}>
                  {dayjs(cell.getValue<Date>()).format("h:mm:ss A Z")}
                </Link>
              ),
            },
            {
              accessorKey: "visit_id",
              header: "Visit",
              cell: (cell) => {
                return (
                  <Link href={`/host/visits/${cell.row.getValue("visit_id")}`}>
                    {cell.getValue<number>()}
                  </Link>
                );
              },
            },
            {
              accessorKey: "name",
              header: "Name",
            },
            {
              accessorKey: "tenant_id",
              header: "Tenant",
              accessorFn: (visit) => tenants[visit.tenant_id || ""].name,
              filterFn: tenantFilter,
            },
            {
              accessorKey: "controller-action",
              header: "Controller / Action",
              accessorFn: (visit) =>
                [
                  visit.properties?.params.controller,
                  visit.properties?.params.action,
                ].join("#"),
            },
            {
              accessorKey: "path",
              header: "URL",
              accessorFn: (visit) => visit.properties?.path,
            },
          ]}
        />
      </Stack>
    </HostLayout>
  );
}

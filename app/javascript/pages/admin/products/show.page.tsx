import {
  Badge,
  Box,
  Divider,
  Flex,
  Stack,
  Title,
  useMantineTheme,
} from "@mantine/core";
import dayjs from "dayjs";
import { groupBy, size, sortBy, startCase, sumBy } from "lodash";
import { DataTable } from "mantine-datatable";
import { useMemo } from "react";
import {
  Bar,
  CartesianGrid,
  ComposedChart,
  Legend,
  Line,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import { AdminLayout } from "~/components/layout/admin-layout";
import { Statistic } from "~/components/statistic";
import { actions } from "~/routes";
import { usePage } from "~/utils/use-page";

interface Props {
  product: App.Product;
  variants: App.Variant[];
  registrations: WithOptional<App.Registration, "user">[];
}

function useVariants(
  variants: App.Variant[],
  registrations: App.Registration[]
) {
  return useMemo(() => {
    const completed = registrations.filter(
      (registration) => registration.completed_at !== null
    );
    const byVariant = groupBy(
      completed,
      (registration) => registration.variant_id
    );

    return variants.map((variant) => {
      return {
        ...variant,
        registrations_count: byVariant[variant.id]?.length || 0,
      };
    });
  }, [variants, registrations]);
}

function useVariantNames(variants: App.Variant[]) {
  return useMemo(() => {
    return variants.reduce((result, current) => {
      result[current.id] = current.title!;
      return result;
    }, {} as Record<number, string>);
  }, [variants]);
}

function useRegistrationsByDate(registrations: App.Registration[]) {
  if (registrations.length == 0) {
    return [];
  }

  return useMemo(() => {
    const ordered = sortBy(
      registrations,
      (registration) => registration.created_at
    );
    const earliestDate = dayjs(ordered[0].created_at);
    const lastDate = dayjs(ordered[ordered.length - 1].created_at);

    const completed = ordered.filter(
      (registration) => !!registration.completed_at
    );
    const grouped = groupBy(completed, (registration) =>
      dayjs(registration.completed_at).format("YYYY-MM-DD")
    );

    const results: Array<{
      date: string;
      count: number;
      revenue: number;
      totalCount: number;
      totalRevenue: number;
    }> = [];

    for (
      let current = earliestDate;
      current.isBefore(lastDate.add(1, "day"), "date");
      current = current.add(1, "day")
    ) {
      const previous = results.length ? results[results.length - 1] : null;

      const r = grouped[current.format("YYYY-MM-DD")];

      const count = size(r) || 0;
      const revenue = sumBy(r, (registration) =>
        parseFloat((registration.price as unknown as string) || "0")
      );

      results.push({
        date: current.format("M/D/YY"),
        count,
        revenue,
        totalCount: previous ? previous.totalCount + count : count,
        totalRevenue: previous ? previous.totalRevenue + revenue : revenue,
      });
    }

    return results;
  }, [registrations]);
}

const currency = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",

  // These options are needed to round to whole numbers if that's what you want.
  //minimumFractionDigits: 0, // (this suffices for whole numbers, but will print 2500.10 as $2,500.1)
  //maximumFractionDigits: 0, // (causes 2500.99 to be printed as $2,501)
});

export default function AdminProductsShowPage() {
  const { props } = usePage<Props>();
  const { product } = props;

  const theme = useMantineTheme();

  const variants = useVariants(props.variants, props.registrations);
  const variantNames = useVariantNames(props.variants);
  const registrations = sortBy(
    props.registrations,
    (registration) => registration.created_at
  ).reverse();

  const byDate = useRegistrationsByDate(registrations);

  return (
    <AdminLayout
      title={product.title!}
      breadcrumbs={[
        { label: "Admin", href: actions["admin/dashboard"]["index"].path({}) },
        {
          label: "Products",
          href: actions["admin/products"]["index"].path({}),
        },
      ]}
    >
      <Stack>
        <Box
          sx={(theme) => ({
            borderColor: theme.colors.gray[3],
            borderWidth: 1,
            borderStyle: "solid",
            padding: theme.spacing.md,
          })}
        >
          <Flex>
            <Statistic
              value={byDate.length ? byDate[byDate.length - 1].totalCount : 0}
              label="Registrations"
              boxStyle={{ flexGrow: 1 }}
            />
            <Divider size="sm" orientation="vertical" />
            <Statistic
              value={currency.format(
                byDate.length ? byDate[byDate.length - 1].totalRevenue : 0
              )}
              label="Revenue"
              boxStyle={{ flexGrow: 1 }}
            />
          </Flex>
        </Box>

        <Box
          sx={(theme) => ({
            borderColor: theme.colors.gray[3],
            borderWidth: 1,
            borderStyle: "solid",
            padding: theme.spacing.md,
          })}
        >
          <ResponsiveContainer width="100%" height={300}>
            <ComposedChart
              data={byDate}
              width={500}
              height={300}
              margin={{
                top: 5,
                right: 30,
                left: 10,
                bottom: 5,
              }}
            >
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="date" />
              <YAxis />
              <Tooltip
                formatter={(value, name) => [value, startCase(name.toString())]}
              />
              <Legend formatter={startCase} />
              <Bar dataKey="count" fill={theme.colors.blue[4]} />
              <Line
                dataKey="totalCount"
                type="monotone"
                stroke={theme.colors.green[4]}
              />
            </ComposedChart>
          </ResponsiveContainer>
        </Box>

        <Title order={3}>Variants</Title>
        <DataTable
          withBorder
          withColumnBorders
          records={variants}
          columns={[
            { accessor: "title", title: "Name" },
            {
              accessor: "price",
              render: (record) => currency.format(record.price || 0),
            },
            {
              accessor: "registrations",
              render: (record) =>
                `${record.registrations_count} / ${
                  record.quantity_allowed || "∞"
                }`,
            },
          ]}
        />

        <Title order={3}>Latest Registrations</Title>
        <DataTable
          withBorder
          withColumnBorders
          records={registrations.slice(0, 10)}
          columns={[
            { accessor: "id" },
            {
              accessor: "name",
              render: (record) => `${record.first_name} ${record.last_name}`,
            },
            {
              accessor: "email",
            },
            {
              accessor: "variant",
              render: (record) =>
                record.variant_id ? variantNames[record.variant_id] : null,
            },
            {
              accessor: "price",
              render: (record) => currency.format(record.price || 0),
            },
            {
              accessor: "date-time",
              title: "Date / Time",
              render: (record) => {
                const datetime = dayjs(record.created_at);
                return `${datetime.format("ddd M/D/YY")} at ${datetime.format(
                  "h:mm a"
                )}`;
              },
            },
            {
              accessor: "status",
              textAlignment: "center",
              render: (record) => <RegistrationStatus registration={record} />,
            },
          ]}
        />
      </Stack>
    </AdminLayout>
  );
}

function RegistrationStatus({
  registration,
}: {
  registration: App.Registration;
}) {
  let color = "yellow";
  let status = "pending";

  if (!!registration.completed_at) {
    color = "green";
    status = "completed";
  }
  if (!!registration.abandoned_at) {
    color = "dark";
    status = "abandoned";
  }
  if (!!registration.cancelled_at) {
    color = "red";
    status = "cancelled";
  }
  return (
    <Badge color={color} radius="sm">
      {status}
    </Badge>
  );
}

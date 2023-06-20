import { Button, Group, Stack, TextInput } from "@mantine/core";
import { IconSearch } from "@tabler/icons-react";
import dayjs from "dayjs";
import { keyBy } from "lodash";
import { DataTable } from "mantine-datatable";
import { useMemo } from "react";
import { SubmitButton, ZoomLinkButton } from "~/components/buttons";
import { AdminLayout } from "~/components/layout/admin-layout";
import { actions } from "~/routes";
import { useFilter } from "~/utils/use-filter";
import { usePage } from "~/utils/use-page";
import { usePagination } from "~/utils/use-pagination";
import { useSorting } from "~/utils/use-sorting";

interface Props {
  products: App.Product[];
  registrations: Registration.Summarization.ByProduct[];
  events: Event.Registrable[];
}

function useProducts(props: Props) {
  const products = useMemo(() => {
    const registrations = keyBy(props.registrations, (reg) => reg.product_id);
    const events = keyBy(props.events, (event) => event.id);

    return props.products.map((product) => {
      const record = {
        ...product,
        registration: registrations[product.id],
        event: product.registrable_id ? events[product.registrable_id] : null,
      };
      record.registration.completed_value = parseFloat(
        record.registration.completed_value.toString()
      );
      return record;
    });
  }, []);

  return products;
}

function renderEvent(product: Unpacked<ReturnType<typeof useProducts>>) {
  const event = product.event;
  return event ? dayjs(event.starts_on).format("ddd M/D/YY h:mm a") : "";
}

const currency = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",

  // These options are needed to round to whole numbers if that's what you want.
  //minimumFractionDigits: 0, // (this suffices for whole numbers, but will print 2500.10 as $2,500.1)
  //maximumFractionDigits: 0, // (causes 2500.99 to be printed as $2,501)
});

export default function AdminProductsIndexPage() {
  const { props } = usePage<Props>();

  const products = useProducts(props);
  const nameFilter = useFilter(products, {
    key: "name",
    filter: (record, value) =>
      !!record.title?.toLowerCase().includes(value.toLowerCase()),
  });
  const sorting = useSorting(nameFilter.records, "updated_at");
  const pagination = usePagination(sorting.records);

  return (
    <AdminLayout
      title="Products"
      breadcrumbs={[
        { label: "Admin", href: actions["admin/dashboard"]["index"].path({}) },
        {
          label: "Products",
          href: actions["admin/products"]["index"].path({}),
        },
      ]}
    >
      <Stack>
        <DataTable
          withBorder
          withColumnBorders
          {...sorting}
          {...pagination}
          columns={[
            {
              accessor: "id",
              render: (product) => (
                <ZoomLinkButton
                  href={actions["next/admin/products"]["show"].path({
                    id: product.id,
                  })}
                />
              ),
              title: "",
              width: "1%",
            },
            {
              accessor: "title",
              filter: ({ close }) => (
                <form {...nameFilter.formProps}>
                  <Stack spacing="xs">
                    <TextInput
                      placeholder="Search title..."
                      icon={<IconSearch size={16} />}
                      {...nameFilter.form.getInputProps("name")}
                    />
                    <Group spacing="xs">
                      <SubmitButton size="xs"></SubmitButton>
                      <Button type="reset" size="xs" variant="default">
                        Clear
                      </Button>
                    </Group>
                  </Stack>
                </form>
              ),
              filtering: nameFilter.active,
            },
            {
              accessor: "event",
              title: "Date / Time",
              render: renderEvent,
              sortable: true,
            },
            {
              accessor: "registration.pending_count",
              title: "Pending",
              textAlignment: "right",
              sortable: true,
            },
            {
              accessor: "registration.abandoned_count",
              title: "Abandoned",
              textAlignment: "right",
              sortable: true,
            },
            {
              accessor: "registration.cancelled_count",
              title: "Cancelled",
              textAlignment: "right",
              sortable: true,
            },
            {
              accessor: "registration.completed_count",
              title: "Completed",
              textAlignment: "right",
              sortable: true,
            },
            {
              accessor: "registration.completed_value",
              title: "Revenue",
              textAlignment: "right",

              render: (record) =>
                currency.format(record.registration.completed_value),
              sortable: true,
            },
          ]}
        />
      </Stack>
    </AdminLayout>
  );
}

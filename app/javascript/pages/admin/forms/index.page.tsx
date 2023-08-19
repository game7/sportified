import { Stack } from "@mantine/core";
import { DataTable } from "mantine-datatable";
import { ZoomLinkButton } from "~/components/buttons";
import { AdminLayout } from "~/components/layout/admin-layout";
import { actions } from "~/routes";
import { usePage } from "~/utils/use-page";

interface Props {
  packets: App.FormPacket[];
}

export default function AdminFormsIndexPage() {
  const { packets } = usePage<Props>().props;

  return (
    <AdminLayout
      title="Forms"
      breadcrumbs={[
        {
          label: "Forms",
          href: actions["next/admin/forms"]["index"].path({}),
        },
      ]}
      extra={[]}
    >
      <Stack>
        <DataTable
          records={packets}
          columns={[
            {
              accessor: "id",
              render: (packet) => (
                <ZoomLinkButton
                  href={actions["next/admin/forms/form_packets"]["show"].path({
                    id: packet.id,
                  })}
                />
              ),
              title: "",
              width: "1%",
            },
            {
              accessor: "name",
            },
          ]}
          withBorder
          withColumnBorders
        />
      </Stack>
    </AdminLayout>
  );
}

import { Stack } from "@mantine/core";
import { DataTable } from "mantine-datatable";
import { ZoomLinkButton } from "~/components/buttons";
import { AdminLayout } from "~/components/layout/admin-layout";
import { actions } from "~/routes";
import { usePage } from "~/utils/use-page";

interface Props {
  packet: App.FormPacket;
  templates: App.FormTemplate[];
}

export default function AdminFormsFormPacketsShowPage() {
  const { packet, templates } = usePage<Props>().props;

  return (
    <AdminLayout
      title={packet.name || ""}
      breadcrumbs={[
        {
          label: "Admin",
          href: actions["next/admin/dashboard"]["index"].path({}),
        },
        {
          label: "Forms",
          href: actions["next/admin/forms"]["index"].path({}),
        },
        {
          label: packet.name || "",
          href: actions["next/admin/forms/form_packets"]["show"].path({
            id: packet.id,
          }),
        },
      ]}
      extra={[]}
    >
      <Stack>
        <DataTable
          records={templates}
          columns={[
            {
              accessor: "id",
              render: (template) => (
                <ZoomLinkButton
                  href={actions["next/admin/forms/form_templates"]["show"].path(
                    {
                      id: template.id,
                    }
                  )}
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

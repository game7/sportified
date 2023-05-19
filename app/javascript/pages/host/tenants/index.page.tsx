import { Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { Table } from "@mantine/core";
import { ZoomLinkButton } from "~/components/buttons";
import { HostLayout } from "../../../components/layout/host-layout";

interface Props extends App.SharedProps {
  tenants: App.Tenant[];
}

export default function hostTenantsIndexPage() {
  const { tenants } = usePage<Page<Props>>().props;

  return (
    <HostLayout
      title="Tenants"
      breadcrumbs={[{ href: "/host/tenants", label: "Tenants" }]}
    >
      <Table withBorder withColumnBorders>
        <thead>
          <tr>
            <th>Id</th>
            <th>Name</th>
            <th>Slug</th>
          </tr>
        </thead>
        <tbody>
          {tenants.map((tenant) => (
            <tr>
              <td width={40}>
                <ZoomLinkButton href={`/host/tenants/${tenant.id}`} />
              </td>
              <td>{tenant.name}</td>
              <td>{tenant.slug}</td>
            </tr>
          ))}
        </tbody>
      </Table>
    </HostLayout>
  );
}

import { Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { Stack, Title } from "@mantine/core";
import { PropertyTable } from "~/components/tables";
import { HostLayout } from "../../../components/layout/host-layout";

interface Props extends App.SharedProps {
  tenant: App.Tenant;
}

export default function hostTenantsShowPage() {
  const { tenant } = usePage<Page<Props>>().props;

  const { Item } = PropertyTable;

  return (
    <HostLayout
      title="Tenants"
      breadcrumbs={[
        { href: "/host/tenants", label: "Tenants" },
        { href: `/host/tenants/${tenant.id}`, label: tenant.id.toString() },
      ]}
    >
      <Stack>
        <Title order={4}>Basic Info</Title>

        <PropertyTable>
          <Item label="Name">{tenant.name}</Item>
          <Item label="Slug">{tenant.slug}</Item>
          <Item label="Host">{tenant.host}</Item>
        </PropertyTable>

        <Title order={4}>Social Media</Title>

        <PropertyTable>
          <Item label="Twitter Id">{tenant.twitter_id}</Item>
          <Item label="Facebook Id">{tenant.facebook_id}</Item>
          <Item label="Instagram Id">{tenant.instagram_id}</Item>
          <Item label="Foursquare Id">{tenant.foursquare_id}</Item>
          <Item label="Google Plus Id">{tenant.google_plus_id}</Item>
        </PropertyTable>

        <Title order={4}>Stripe Platform Configuration</Title>

        <PropertyTable>
          <Item label="Client ID">{tenant.stripe_client_id}</Item>
          <Item label="Public Key">{tenant.stripe_public_key}</Item>
          <Item label="Private Key">{tenant.stripe_private_key}</Item>
        </PropertyTable>

        <Title order={4}>Stripe Tenant Configuration</Title>

        <PropertyTable>
          <Item label="Access Token">{tenant.stripe_access_token}</Item>
          <Item label="Account Id">{tenant.stripe_account_id}</Item>
          <Item label="Public API Key">{tenant.stripe_public_api_key}</Item>
        </PropertyTable>

        <Title order={4}>Styling</Title>

        <PropertyTable>
          <Item label="Theme">{tenant.theme}</Item>
          <Item label="Style">{tenant.style}</Item>
          <Item label="Google Fonts">{tenant.google_fonts}</Item>
        </PropertyTable>
      </Stack>
    </HostLayout>
  );
}

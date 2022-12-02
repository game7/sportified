import { Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { Descriptions, DescriptionsProps, Space } from "antd";
import { HostLayout } from "../../../components/layout/host-layout";

interface Props extends App.SharedProps {
  tenant: App.Tenant;
}

export default function hostTenantsShowPage() {
  const { tenant } = usePage<Page<Props>>().props;

  const { Item } = Descriptions;

  const COMMON_PROPS: DescriptionsProps = {
    bordered: true,
    column: 1,
    labelStyle: {
      width: "20%",
    },
    contentStyle: {
      width: "80%",
    },
  };

  return (
    <HostLayout
      title="Tenants"
      breadcrumbs={[
        { href: "/host/tenants", label: "Tenants" },
        { href: `/host/tenants/${tenant.id}`, label: tenant.id },
      ]}
    >
      <Space direction="vertical" size="large" style={{ display: "flex" }}>
        <Descriptions title="Basic Info" {...COMMON_PROPS}>
          <Item label="Name">{tenant.name}</Item>
          <Item label="Slug">{tenant.slug}</Item>
          <Item label="Host">{tenant.host}</Item>
        </Descriptions>
        <Descriptions title="Social Media" {...COMMON_PROPS}>
          <Item label="Twitter Id">{tenant.twitter_id}</Item>
          <Item label="Facebook Id">{tenant.facebook_id}</Item>
          <Item label="Instagram Id">{tenant.instagram_id}</Item>
          <Item label="Foursquare Id">{tenant.foursquare_id}</Item>
          <Item label="Google Plus Id">{tenant.google_plus_id}</Item>
        </Descriptions>
        <Descriptions title="Stripe Platform Configuration" {...COMMON_PROPS}>
          <Item label="Client ID">{tenant.stripe_client_id}</Item>
          <Item label="Public Key">{tenant.stripe_public_key}</Item>
          <Item label="Private Key">{tenant.stripe_private_key}</Item>
        </Descriptions>
        <Descriptions title="Stripe Tenant Configuration" {...COMMON_PROPS}>
          <Item label="Access Token">{tenant.stripe_access_token}</Item>
          <Item label="Account Id">{tenant.stripe_account_id}</Item>
          <Item label="Public API Key">{tenant.stripe_public_api_key}</Item>
        </Descriptions>
        <Descriptions title="Styling" {...COMMON_PROPS}>
          <Item label="Theme">{tenant.theme}</Item>
          <Item label="Style">{tenant.style}</Item>
          <Item label="Google Fonts">{tenant.google_fonts}</Item>
        </Descriptions>
      </Space>
    </HostLayout>
  );
}

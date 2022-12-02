import {
  AlertOutlined,
  GlobalOutlined,
  OrderedListOutlined,
} from "@ant-design/icons";
import { Link } from "@inertiajs/inertia-react";
import { FC } from "react";
import { BaseLayout, BaseLayoutProps } from "./base-layout";

export const HostLayout: FC<BaseLayoutProps> = ({
  breadcrumbs = [],
  ...props
}) => {
  breadcrumbs.unshift({ label: "Host", href: "/host" });
  return (
    <BaseLayout
      {...props}
      breadcrumbs={breadcrumbs}
      sidebar={[
        {
          key: "/host/visits",
          label: <Link href="/host/visits">Visits</Link>,
          icon: <GlobalOutlined />,
        },
        {
          key: "/host/events",
          label: <Link href="/host/events">Events</Link>,
          icon: <OrderedListOutlined />,
        },
        {
          key: "/host/exceptions",
          label: <Link href="/host/exceptions">Exceptions</Link>,
          icon: <AlertOutlined />,
        },
      ]}
    ></BaseLayout>
  );
};

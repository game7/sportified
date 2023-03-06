import { HomeOutlined } from "@ant-design/icons";
import { Page } from "@inertiajs/inertia";
import { Head, Link, usePage } from "@inertiajs/inertia-react";
import {
  Affix,
  Alert,
  AlertProps,
  Breadcrumb,
  BreadcrumbProps,
  Layout,
  Menu,
  MenuProps,
  PageHeader,
  PageHeaderProps,
} from "antd";
import Sider from "antd/lib/layout/Sider";
import { ItemType, MenuItemGroupType } from "antd/lib/menu/hooks/useItems";
import { get } from "lodash";
import React, { FC, PropsWithChildren, useState } from "react";
import { useLocalStorage } from "~/utils/use-local-storage";
import "./base-layout.css";

export interface Breadcrumb {
  label: string;
  href: string;
}

export type BaseLayoutProps = PropsWithChildren<{
  title: string;
  subTitle?: PageHeaderProps["subTitle"];
  pageHeader?: boolean;
  breadcrumbs?: Breadcrumb[];
  tags?: PageHeaderProps["tags"];
  extra?: PageHeaderProps["extra"];
  onBack?: PageHeaderProps["onBack"];
  sidebar?: ItemType[];
  fluid?: boolean;
}>;

type MenuItem = Required<MenuProps>["items"][number];

function getItem(
  label: React.ReactNode,
  key: React.Key,
  icon?: React.ReactNode,
  children?: MenuItem[]
): MenuItem {
  return {
    key,
    icon,
    children,
    label,
  } as MenuItem;
}

export const BaseLayout: FC<BaseLayoutProps> = ({
  title,
  subTitle,
  pageHeader = true,
  extra,
  sidebar,
  breadcrumbs,
  tags,
  fluid,
  children,
}) => {
  const page = usePage<Page<App.SharedProps>>();
  const { flash } = page.props;

  const [collapsed, setCollapsed] = useLocalStorage("layout-sidebar", false);

  // extract href from menu item label and compare to current
  // window.location in order to identify menu items that should
  // be marked as selected
  const [state, setState] = useState<{
    openKeys: string[];
    selectedKeys: string[];
  }>(() => {
    const openKeys: string[] = [];
    const selectedKeys: string[] = [];

    sidebar?.forEach((item) => {
      const key = (item?.key || Date.now).toString();

      if ((item as MenuItemGroupType).children) {
        if (window.location.pathname.startsWith(key)) {
          collapsed ? selectedKeys.push(key) : openKeys.push(key);
        }
        (item as MenuItemGroupType).children?.forEach((child) => {
          const childKey = (child?.key || Date.now).toString();
          if (window.location.pathname.startsWith(childKey)) {
            selectedKeys.push(childKey);
          }
        });
      } else {
        if (window.location.pathname.startsWith(key)) {
          selectedKeys.push(key);
        }
      }
    });

    return {
      openKeys,
      selectedKeys,
    };
  });

  const { openKeys, selectedKeys } = state;

  function setOpenKeys(keys: string[]) {
    setState((current) => ({ ...current, openKeys: keys }));
  }

  const pageHeaderBreadcrumb: BreadcrumbProps = {
    routes: [
      {
        path: "/",
        breadcrumbName: "APP_HOME",
      },
      ...(breadcrumbs || []).map((crumb) => {
        return {
          path: crumb.href,
          breadcrumbName: crumb.label,
        };
      }),
    ],
    itemRender: (route) =>
      route.breadcrumbName == "APP_HOME" ? (
        <a key={route.path} href={route.path}>
          <HomeOutlined />
        </a>
      ) : (
        <Link key={route.path} href={route.path}>
          {route.breadcrumbName}
        </Link>
      ),
  };

  return (
    <React.Fragment>
      <Head title={title ? `${title} | Sportfied` : "Sportified"}></Head>
      <Layout style={{ minHeight: "100vh", flexDirection: "row" }}>
        <Sider
          collapsible
          collapsed={collapsed}
          onCollapse={(value) => setCollapsed(value)}
          style={{
            overflow: "auto",
            height: "100vh",
            position: "fixed",
            left: 0,
            top: 0,
            bottom: 0,
          }}
        >
          <div className="logo" />
          <Menu
            theme="dark"
            selectedKeys={selectedKeys}
            openKeys={openKeys}
            onOpenChange={setOpenKeys}
            mode="inline"
            inlineCollapsed={collapsed}
            items={sidebar}
          />
        </Sider>
        <Layout
          className="site-layout"
          style={{ marginLeft: collapsed ? 80 : 200, transition: "all .2s" }}
        >
          <Layout.Header
            className="site-layout-background"
            style={{
              padding: 0,
              display: "flex",
              flexDirection: "column",
              justifyContent: "center",
              position: "fixed",
              left: collapsed ? 80 : 200,
              top: 0,
              right: 0,
              transition: "all .2s",
              zIndex: 10,
            }}
          >
            <Breadcrumb
              style={{ margin: "0 16px" }}
              {...pageHeaderBreadcrumb}
            ></Breadcrumb>
          </Layout.Header>
          <div className="outer-container">
            <Layout.Content
              className={`main-page-container${fluid ? " fluid" : ""}`}
            >
              {pageHeader && (
                <Affix offsetTop={-8}>
                  <PageHeader
                    title={title}
                    subTitle={subTitle}
                    tags={tags}
                    extra={extra}
                    style={{
                      padding: 16,
                      backgroundColor: "#fff",
                      borderBottom: "2px solid #f0f2f5",
                    }}
                  ></PageHeader>
                </Affix>
              )}

              <FlashAlerts flash={flash}></FlashAlerts>

              <div
                className="site-layout-background"
                style={{ padding: 24, minHeight: 360 }}
              >
                {children}
              </div>
              {/* <div className="main-page-container">
              <FlashAlerts flash={flash}></FlashAlerts>
              {!!pageHeader && (
                    <Affix offsetTop={64}>
                      <PageHeader
                        title={title}
                        subTitle={subTitle}
                        tags={tags}
                        extra={extra}
                        breadcrumb={pageHeaderBreadcrumb}
                        style={{
                          backgroundColor: "#fff",
                          borderTop: "2px solid #f0f2f5",
                          borderBottom: "2px solid #f0f2f5",
                        }}
                      ></PageHeader>
                    </Affix>
                  )}
              <div className="site-layout-content">{children}</div>
            </div> */}
            </Layout.Content>
          </div>
        </Layout>
      </Layout>
    </React.Fragment>
  );
};

interface SidebarProps {
  items: ItemType[];
}

function SideBar({ items }: SidebarProps) {
  // extract href from menu item label and compare to current
  // window.location in order to identify menu items that should
  // be marked as selected
  const selectedKeys = items
    .map((item) => get(item, "label.props.href"))
    .filter((href) => {
      return window.location.href.includes(href);
    });
  return (
    <Layout.Sider>
      <Menu
        mode="inline"
        style={{ height: "100%" }}
        items={items}
        {...{ selectedKeys }}
      ></Menu>
    </Layout.Sider>
  );
}

function FlashAlerts({ flash = {} }: { flash?: App.Flash }) {
  const FLASH_ALERT_TYPES: Record<App.FlashType, AlertProps["type"]> = {
    notice: "info",
    error: "error",
    info: "info",
    warning: "warning",
    success: "success",
  };

  const alerts = Object.entries(flash).map(([key, message]) => [
    FLASH_ALERT_TYPES[key as App.FlashType],
    message,
  ]);

  return (
    <React.Fragment>
      {alerts.map(([type, message]) => (
        <Alert
          key={type}
          type={type as AlertProps["type"]}
          message={message}
          showIcon
          closable
        ></Alert>
      ))}
    </React.Fragment>
  );
}

// function UserProfileWidget({ user }: { user: App.User }) {
//   const initials = (user.fname || "")[0] + (user.lname || "")[0];
//   const displayName = [user.fname, user.lname].join(" ");
//   return (
//     <Menu
//       theme="dark"
//       mode="horizontal"
//       style={{ minWidth: 0, flex: "auto", justifyContent: "flex-end" }}
//       items={[
//         {
//           key: "user",
//           label: (
//             <Space>
//               <Avatar
//                 style={{
//                   backgroundColor: "#7bdeff",
//                   verticalAlign: "middle",
//                 }}
//               >
//                 {initials}
//               </Avatar>
//               <span style={{ color: "white", fontSize: "14px" }}>
//                 {displayName}
//               </span>
//             </Space>
//           ),
//           children: [
//             {
//               key: "profile",
//               label: <Link href="/profile">Profile</Link>,
//             },
//           ],
//         },
//       ]}
//     />
//   );
// }

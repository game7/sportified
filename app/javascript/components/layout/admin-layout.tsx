import { Link } from "@inertiajs/inertia-react";
import {
  AppShell,
  Breadcrumbs,
  Burger,
  Footer,
  Group,
  Header,
  MediaQuery,
  Navbar,
  Stack,
  Text,
  ThemeIcon,
  Title,
  UnstyledButton,
  useMantineTheme,
} from "@mantine/core";
import { useDocumentTitle } from "@mantine/hooks";
import {
  IconAssembly,
  IconCalendar,
  IconCalendarDown,
  IconForms,
  IconMapPin,
  TablerIconsProps,
} from "@tabler/icons-react";
import { FC, useState } from "react";
import { BaseLayoutProps, Breadcrumb } from "./base-layout";

type Icon = (props: TablerIconsProps) => JSX.Element;

type MenuItem = {
  href: string;
  label: string;
  icon: Icon;
  color: string;
};

const color = (() => {
  const colors = ["blue", "teal", "violet", "yellow"] as const;
  let count = 0;
  return () => {
    const color = colors[count];
    count++;
    if (count === colors.length) {
      count = 0;
    }
    return color;
  };
})();

const menuItems: MenuItem[] = [
  {
    href: "/next/admin/events/calendar",
    label: "Calendar",
    icon: IconCalendar,
    color: color(),
  },
  {
    href: "/next/admin/events/planner",
    label: "Planner",
    icon: IconCalendarDown,
    color: color(),
  },
  {
    href: "/next/admin/locations",
    label: "Locations",
    icon: IconMapPin,
    color: color(),
  },

  {
    href: "/next/admin/forms",
    label: "Forms",
    icon: IconForms,
    color: color(),
  },
  {
    href: "/next/admin/products",
    label: "Products",
    icon: IconAssembly,
    color: color(),
  },
];

export const AdminLayout: FC<BaseLayoutProps> = ({
  breadcrumbs = [],
  ...props
}) => {
  breadcrumbs = [{ label: "Admin", href: "/Admin" }, ...breadcrumbs];

  useDocumentTitle(`${props.title} :: Sportified`);

  const theme = useMantineTheme();
  const [opened, setOpened] = useState(false);

  return (
    <AppShell
      styles={{
        main: {
          background:
            theme.colorScheme === "dark"
              ? theme.colors.dark[8]
              : theme.colors.gray[0],
        },
      }}
      navbarOffsetBreakpoint="sm"
      asideOffsetBreakpoint="sm"
      navbar={
        <Navbar
          p="md"
          hiddenBreakpoint="sm"
          hidden={!opened}
          width={{ sm: 200, lg: 300 }}
        >
          {menuItems.map((item) => (
            <MainLink
              key={item.label}
              label={item.label}
              icon={<item.icon />}
              color={item.color}
              href={item.href}
            />
          ))}
        </Navbar>
      }
      // aside={
      //   <MediaQuery smallerThan="sm" styles={{ display: "none" }}>
      //     <Aside p="md" hiddenBreakpoint="sm" width={{ sm: 200, lg: 300 }}>
      //       <Text>Application sidebar</Text>
      //     </Aside>
      //   </MediaQuery>
      // }
      footer={
        <Footer height={60} p="md">
          Application footer
        </Footer>
      }
      header={
        <Header height={{ base: 50, md: 70 }} p="md">
          <div
            style={{ display: "flex", alignItems: "center", height: "100%" }}
          >
            <MediaQuery largerThan="sm" styles={{ display: "none" }}>
              <Burger
                opened={opened}
                onClick={() => setOpened((o) => !o)}
                size="sm"
                color={theme.colors.gray[6]}
                mr="xl"
              />
            </MediaQuery>

            <Text>Application header</Text>
          </div>
        </Header>
      }
    >
      <div style={{ display: "flex", justifyContent: "center" }}>
        <Stack
          style={{
            width: props.fluid ? "" : 1140,
          }}
        >
          <PageHeader title={props.title} breadcrumbs={breadcrumbs} />

          <div
            style={{
              backgroundColor: "white",
              padding: 20,
            }}
          >
            {props.children}
          </div>
        </Stack>
      </div>
    </AppShell>
  );
};

interface PageHeaderProps {
  title: string;
  breadcrumbs: Breadcrumb[];
}

function PageHeader({ title, breadcrumbs }: PageHeaderProps) {
  return (
    <div
      style={{
        backgroundColor: "white",
        padding: 20,
      }}
    >
      <Stack spacing="xs">
        <Breadcrumbs>
          {breadcrumbs.map((crumb) => (
            <Link key={crumb.label} href={crumb.href}>
              {crumb.label}
            </Link>
          ))}
        </Breadcrumbs>
        <Title>{title}</Title>
      </Stack>
    </div>
  );
}

interface MainLinkProps {
  icon: React.ReactNode;
  color: string;
  label: string;
  href: string;
  active?: boolean;
}

function MainLink({ icon, color, label, href, active = false }: MainLinkProps) {
  return (
    <Link href={href}>
      <UnstyledButton
        sx={(theme) => ({
          display: "block",
          width: "100%",
          padding: theme.spacing.xs,
          borderRadius: theme.radius.sm,
          color:
            theme.colorScheme === "dark" ? theme.colors.dark[0] : theme.black,

          "&:hover": {
            backgroundColor:
              theme.colorScheme === "dark"
                ? theme.colors.dark[6]
                : theme.colors.gray[0],
          },
        })}
      >
        <Group>
          <ThemeIcon color={color} variant="light">
            {icon}
          </ThemeIcon>

          <Text size="sm">{label}</Text>
        </Group>
      </UnstyledButton>
    </Link>
  );
}

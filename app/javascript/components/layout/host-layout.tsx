import { Link } from "@inertiajs/inertia-react";
import {
  AppShell,
  Aside,
  Burger,
  Footer,
  Group,
  Header,
  MediaQuery,
  Navbar,
  Text,
  ThemeIcon,
  UnstyledButton,
  useMantineTheme,
} from "@mantine/core";
import {
  IconAppWindow,
  IconExclamationCircle,
  IconList,
  IconWorld,
  TablerIconsProps,
} from "@tabler/icons-react";
import { FC, useState } from "react";
import { BaseLayoutProps } from "./base-layout";

type Icon = (props: TablerIconsProps) => JSX.Element;

type MenuItem = {
  href: string;
  label: string;
  icon: Icon;
  color: string;
};

const menuItems: MenuItem[] = [
  {
    href: "/host/tenants",
    label: "Tenants",
    icon: IconAppWindow,
    color: "blue",
  },
  { href: "/host/visits", label: "Visits", icon: IconWorld, color: "teal" },
  { href: "/host/events", label: "Events", icon: IconList, color: "violet" },
  {
    href: "/host/exceptions",
    label: "Exceptions",
    icon: IconExclamationCircle,
    color: "grape",
  },
];

export const HostLayout: FC<BaseLayoutProps> = ({
  breadcrumbs = [],
  ...props
}) => {
  breadcrumbs.unshift({ label: "Host", href: "/host" });

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
      aside={
        <MediaQuery smallerThan="sm" styles={{ display: "none" }}>
          <Aside p="md" hiddenBreakpoint="sm" width={{ sm: 200, lg: 300 }}>
            <Text>Application sidebar</Text>
          </Aside>
        </MediaQuery>
      }
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
        <div style={{ backgroundColor: "white", padding: 20, width: 1140 }}>
          {props.children}
        </div>
      </div>
    </AppShell>
  );
};

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

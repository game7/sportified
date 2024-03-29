import { CalendarOutlined } from "@ant-design/icons";
import {
  faBuilding,
  faFile,
  faStickyNote,
  faUser,
} from "@fortawesome/free-regular-svg-icons";
import { faCashRegister, faTrophy } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Link } from "@inertiajs/inertia-react";
import { FC } from "react";
import { paths } from "~/routes";
import { BaseLayout, BaseLayoutProps } from "./base-layout";

export const AdminLayout: FC<BaseLayoutProps> = ({
  breadcrumbs = [],
  ...props
}) => {
  breadcrumbs.unshift({ label: "Admin", href: "/next/admin" });
  return (
    <BaseLayout
      {...props}
      breadcrumbs={breadcrumbs}
      sidebar={[
        {
          key: "/next/admin/events",
          label: "Events",
          icon: <CalendarOutlined />,
          children: [
            {
              key: paths["/next/admin/events/calendar"].path({}),
              label: (
                <Link href={paths["/next/admin/events/calendar"].path({})}>
                  Calendar
                </Link>
              ),
            },
            {
              key: paths["/next/admin/events/planner"].path({}),
              label: (
                <Link href={paths["/next/admin/events/planner"].path({})}>
                  Planner
                </Link>
              ),
            },
          ],
        },

        // {
        //   key: "/next/admin/leagues",
        //   label: <Link href="/next/admin/leagues">Leagues</Link>,
        //   icon: <FontAwesomeIcon icon={faTrophy} />,
        // },
        // {
        //   key: "/next/admin/pages",
        //   label: <Link href="/next/admin/pages">Pages</Link>,
        //   icon: <FontAwesomeIcon icon={faFile} />,
        // },
        // {
        //   key: "/next/admin/posts",
        //   label: <Link href="/next/admin/posts">Posts</Link>,
        //   icon: <FontAwesomeIcon icon={faStickyNote} />,
        // },
        // {
        //   key: "/next/admin/users",
        //   label: <Link href="/next/admin/users">Users</Link>,
        //   icon: <FontAwesomeIcon icon={faUser} />,
        // },

        {
          key: "/next/admin/locations",
          label: <Link href="/next/admin/locations">Locations</Link>,
          icon: <FontAwesomeIcon icon={faBuilding} />,
        },

        // {
        //   key: "/next/admin/locationsx",
        //   label: <Link href="/next/admin/locationsx">Registration</Link>,
        //   icon: <FontAwesomeIcon icon={faCashRegister} />,
        // },
      ]}
    ></BaseLayout>
  );
};

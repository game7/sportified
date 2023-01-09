import {
  EditOutlined,
  EllipsisOutlined,
  PictureOutlined,
  PlusOutlined,
} from "@ant-design/icons";
import { Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Button, Dropdown, Image, Popover, Table } from "antd";
import { LinkButton } from "~/components/buttons";
import { AdminLayout } from "~/components/layout/admin-layout";

interface Props extends App.SharedProps {
  posts: any[];
}

export default function AdminPostsIndexPage() {
  const { props } = usePage<Page<Props>>();
  const { posts } = props;

  return (
    <AdminLayout
      title="Posts"
      breadcrumbs={[{ label: "Posts", href: "/next/admin/posts" }]}
      extra={[
        <LinkButton
          key="new"
          href="/next/admin/posts/new"
          icon={<PlusOutlined />}
        >
          New Post
        </LinkButton>,
      ]}
    >
      <Table
        dataSource={posts}
        rowKey="id"
        columns={[
          {
            dataIndex: "id",
            render: (id) => (
              <Dropdown
                menu={{
                  items: [
                    {
                      key: "edit",
                      icon: <EditOutlined />,
                      label: (
                        <Link href={`/next/admin/posts/${id}/edit`}>Edit</Link>
                      ),
                    },
                  ],
                }}
              >
                <a onClick={(e) => e.preventDefault()}>
                  <EllipsisOutlined rotate={90} />
                </a>
              </Dropdown>
            ),
            width: 40,
          },
          {
            dataIndex: "photo_url",
            width: 40,
            render: (url: string) =>
              url && (
                <Popover content={<Image src={url} width={200} />}>
                  <Button icon={<PictureOutlined />} />
                </Popover>
              ),
          },
          { dataIndex: "title", title: "Title" },
        ]}
        bordered
      ></Table>
    </AdminLayout>
  );
}

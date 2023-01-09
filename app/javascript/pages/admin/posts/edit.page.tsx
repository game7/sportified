import { Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { AdminLayout } from "~/components/layout/admin-layout";
import { PostForm } from "./form.component";

interface Props extends App.SharedProps {
  post: App.Post;
}

export default function EditAdminPostsIndexPage() {
  const { props } = usePage<Page<Props>>();
  const { post } = props;

  return (
    <AdminLayout
      title="Editing Post"
      breadcrumbs={[
        { href: "/next/admin/posts", label: "Posts" },
        { href: `/next/admin/posts/${post.id}/edit`, label: "Edit" },
      ]}
    >
      <PostForm />
    </AdminLayout>
  );
}

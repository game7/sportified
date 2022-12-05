import { AdminLayout } from "~/components/layout/admin-layout";
import { PostForm } from "./form.component";

export default function NewAdminPostsIndexPage() {
  return (
    <AdminLayout
      title="New Post"
      breadcrumbs={[
        { href: "/next/admin/posts", label: "Posts" },
        { href: `/next/admin/posts/new`, label: "New" },
      ]}
    >
      <PostForm />
    </AdminLayout>
  );
}

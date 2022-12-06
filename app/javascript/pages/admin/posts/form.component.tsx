import { Inertia, Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import { Form, Input, Space } from "antd";
import { BackButton, SubmitButton } from "~/components/buttons";
import { asPayload, useForm } from "~/utils/use-form";
import { DirectUpload } from "@rails/activestorage";

type Post = App.Post;

type Mode = "create" | "update";

interface Props extends App.SharedProps {
  post: Post;
}

export function PostForm() {
  const { props } = usePage<Page<Props>>();
  const { form, bind } = useForm<Post>(props.post);
  const mode: Mode = props.post.id ? "update" : "create";

  function handleFinish(data: Post) {
    if (props.post.id) {
      Inertia.patch(
        `/next/admin/posts/${props.post.id}`,
        asPayload({ post: data })
      );
    } else {
      Inertia.post("/next/admin/posts", asPayload({ post: data }));
    }
  }

  return (
    <Form form={form} onFinish={handleFinish} layout="vertical">
      <Space direction="vertical" style={{ width: "100%" }}>
        <Form.Item {...bind("title")} required>
          <Input />
        </Form.Item>
        <Form.Item {...bind("summary")}>
          <Input.TextArea rows={3} />
        </Form.Item>
        <Form.Item {...bind("body")}>
          <Input.TextArea
            rows={6}
            onPaste={(e) => {
              const { items, files } = e.clipboardData;
              for (let i = 0; i < items.length; i++) {
                const item = items[i];
                console.log(item);
              }
              for (let i = 0; i < files.length; i++) {
                const file = files[i];
                const data = new FormData();
                data.append("blob", file);
                fetch("/active_storage/blobs", {
                  method: "POST",
                  body: data,
                })
                  .then((res) => res.json())
                  .then((data) => {
                    console.log(data);
                  });
              }
            }}
          />
        </Form.Item>
        <Form.Item>
          <Space>
            <SubmitButton></SubmitButton>
            <BackButton></BackButton>
          </Space>
        </Form.Item>
      </Space>
    </Form>
  );
}

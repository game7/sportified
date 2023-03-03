import { AppstoreOutlined, UploadOutlined } from "@ant-design/icons";
import { Inertia, Page } from "@inertiajs/inertia";
import { usePage } from "@inertiajs/inertia-react";
import {
  Button,
  Form,
  Image,
  Input,
  Modal,
  Space,
  Upload,
  UploadFile,
} from "antd";
import { UploadChangeParam } from "antd/lib/upload";
import React, { ComponentProps, useEffect, useState } from "react";
import { BackButton, SubmitButton } from "~/components/buttons";
import { asPayload, useForm } from "~/utils/use-form";

type Post = App.Post & {
  photo_url: string;
};

type Blob = ActiveStorage.Blob & {
  url: string;
  "image?": boolean;
};

interface Props extends App.SharedProps {
  post: Post;
}

export function PostForm() {
  const { props } = usePage<Page<Props>>();
  const { post } = props;
  const { form, bind } = useForm<Post>(props.post);

  function handleFinish(data: Post) {
    console.log(data);
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
        <Form.Item {...bind("photo")}>
          <ImagePicker url={post.photo_url} />
        </Form.Item>
        <Form.Item {...bind("summary")}>
          <Input.TextArea rows={3} />
        </Form.Item>
        <Form.Item {...bind("body")}>
          <MarkdownEditor />
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

type ImagePickerProps = Omit<ComponentProps<typeof Upload>, "onChange"> & {
  url?: string;
  onChange?: (value: string) => void;
};

function ImagePicker(props: ImagePickerProps) {
  const [url, setUrl] = useState<string | undefined>(props.url);
  const [blobs, setBlobs] = useState<Blob[]>();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const paginated = blobs?.slice(0, 20);

  const thumbnailSize: number = 200;

  const showModal = (e: React.MouseEvent<HTMLElement, MouseEvent>) => {
    setIsModalOpen(true);
    if (!blobs) {
      fetch("/active_storage/blobs")
        .then((res) => res.json())
        .then((data) => {
          setBlobs((data as Blob[]).filter((blob) => blob["image?"] == true));
        });
    }
  };

  const handleOk = () => {
    setIsModalOpen(false);
  };

  const handleCancel = () => {
    setIsModalOpen(false);
  };

  function handleChange(info: UploadChangeParam<UploadFile<any>>) {
    if (info.file.response) {
      setUrl(info.file.response["url"]);
      props.onChange && props.onChange(info.file.response["signed_id"]);
    }
  }

  return (
    <Space direction="vertical" style={{ display: "flex" }}>
      {url && <Image src={url} width={200} />}
      <Upload
        name="blob"
        accept="image/jpeg, image/png"
        action="/active_storage/blobs"
        multiple={false}
        showUploadList={false}
        {...props}
        onChange={handleChange}
      >
        <Space>
          <Button icon={<UploadOutlined />}>Upload an Image</Button>
        </Space>
      </Upload>
      <Button icon={<AppstoreOutlined />} onClick={showModal}>
        Select an Existing Image
      </Button>
      <Modal
        title="Basic Modal"
        open={isModalOpen}
        onOk={handleOk}
        onCancel={handleCancel}
        width="50%"
      >
        <div style={{ display: "flex", gap: "5px" }}>
          {paginated?.map((blob) => (
            <Image
              src={blob.url}
              height={thumbnailSize}
              width={thumbnailSize}
              style={{ objectFit: "cover" }}
            />
          ))}
        </div>
        {/* <Table
          dataSource={blobs}
          rowKey="id"
          columns={[
            {
              dataIndex: "url",
              render: (url) => (
                <Image
                  src={url}
                  height={100}
                  width={100}
                  style={{ objectFit: "cover" }}
                />
              ),
            },
          ]}
          pagination={{
            pageSize: 5,
            showSizeChanger: false,
          }}
        /> */}
      </Modal>
    </Space>
  );
}

type MarkdownEditorProps = Omit<
  ComponentProps<typeof Input.TextArea>,
  "onChange"
> & {
  onChange?: (value: MarkdownEditorProps["value"]) => void;
};

function MarkdownEditor(props: MarkdownEditorProps) {
  const [value, setValue] = useState(props.value);

  useEffect(() => {
    props.onChange && props.onChange(value);
  }, [value]);

  return (
    <React.Fragment>
      <Input.TextArea
        rows={6}
        {...props}
        value={value}
        onChange={(e) => setValue(e.currentTarget.value)}
        onPaste={(e) => {
          const { files } = e.clipboardData;
          let start = e.currentTarget.selectionStart;
          let end = e.currentTarget.selectionEnd;
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
                setValue((value) => {
                  const body = value ? value.toString() : "";
                  const tag = data["image?"]
                    ? `![Alt text](${data.url})`
                    : `[link title](${data.url})`;
                  return [body.substring(0, start), tag, body.slice(end)].join(
                    ""
                  );
                });
              });
          }
        }}
      />
    </React.Fragment>
  );
}

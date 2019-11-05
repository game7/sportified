import React, { FC, useState } from 'react';
import Layout from '../../components/layout'
import { Form, FormProps, TextArea, Button, Grid } from 'semantic-ui-react'
import MarkdownEditor from '../../components/markdown-editor'
import { preview, create, CreatePostPayload } from '../../actions/posts'
import { RouteComponentProps } from 'react-router-dom'

export const PostsNew: FC<RouteComponentProps<{}>> = ({ history }) => {
  const [data, setData] = useState<Partial<CreatePostPayload>>({})
  function handleSubmit() {
    create(data).then(() => {
      history.push('/posts')
    })
  }
  function handlePreview(content: string) {
    return preview({ markdown: content }).then(response => response.preview)
  }
  function bind(attr: keyof CreatePostPayload) {
    return function(event: React.ChangeEvent<HTMLInputElement> | React.ChangeEvent<HTMLTextAreaElement>) {
      setData({
        ...data,
        [attr]: event.target.value
      })
    }
  }
  return (
    <Layout title="New Post">
      <Form onSubmit={handleSubmit}>
        <Form.Input label="Title" onChange={bind('title')} />
        <Form.Field label="Summary" control={TextArea} onChange={bind('summary')} />
        <MarkdownEditor onPreview={handlePreview} onChange={bind('body')} />
        <Button type='submit'>Submit</Button>
      </Form>
    </Layout>
  )
}

export default PostsNew;

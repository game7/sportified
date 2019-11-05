import React, { FC, useState, useEffect } from 'react';
import Layout from "../../components/layout";
import { Post, list } from "../../actions/posts";
import { Dropdown, Table, Header, Image, Button } from 'semantic-ui-react'
import ActionsDropdown  from "../../components/actions-dropdown"
import { Link } from 'react-router-dom';
import moment from 'moment';

export const PostsList: FC<{}> = () => {

  const [posts, setPosts] = useState<Post[]>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    setLoading(true)
    list({}).then(posts => {
      setPosts(posts)
      setLoading(false)
    })
  }, [])

  const actions = (
    <Button as={Link} to="/posts/new" content="New Post" icon="plus"/>
  )

  return (
    <Layout title="Posts" actions={actions}>
      <Table>
        <Table.Body>
          {posts.map(post => (
            <Table.Row key={post.id}>
              <Table.Cell>
                <Header as="h3">{post.title || 'untitled'}</Header>
                {moment(post.createdAt).format('MMM D, YYYY h:mm A')}
              </Table.Cell>
              <Table.Cell>
                {post.thumbUrl && (
                  <Image src={post.thumbUrl} floated="right" size="tiny"></Image>
                )}
              </Table.Cell>
              <Table.Cell>
                <ActionsDropdown>
                  <Dropdown.Item as={Link} to={`/posts/${post.id}/edit`} icon="edit" text="Edit" />
                </ActionsDropdown>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </Layout>
  )
}

export default PostsList;


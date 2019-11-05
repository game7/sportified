import React, { FC, useState, useEffect } from 'react';
import Layout from "../../components/layout";
import { Page, list } from "../../actions/pages";
import { List } from 'semantic-ui-react'
import { Link } from 'react-router-dom';

export const PagesList: FC<{}> = () => {

  const [pages, setPages] = useState<Page[]>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    setLoading(true)
    list({}).then(pages => {
      setPages(pages)
      setLoading(false)
    })
  }, [])

  const top = pages.filter(p => p.ancestryDepth === 0)

  return (
    <Layout title="Pages">
      <List divided>
        {pages.map(page => (
          <List.Item key={page.id} style={{ paddingLeft: (page.ancestryDepth * 20) }}>
            <List.Icon name='file' />
            <List.Content>
              <List.Header as={Link} to={`/pages/${page.id}`}>{page.title}</List.Header>
            </List.Content>
          </List.Item>
        ))}
      </List>
      <List divided>
        {top.map(page => (
          <PageTree key={page.id} page={page} pages={pages} />
        ))}
      </List>
    </Layout>
  )
}

export default PagesList;

const PageTree: FC<{ page: Page, pages: Page[] }> = ({ page, pages }) => {
  const children = pages.filter(other => {
    if(!other.ancestry) return false;
    const ancestors = other.ancestry.split('/');
    const last = ancestors[ancestors.length - 1]
    return last === page.id.toString()
  })
  return (
    <List.Item>
      <List.Icon name='file' />
      <List.Content>
        <List.Header as={Link} to={`/pages/${page.id}`}>{page.title}</List.Header>
        <List.List>
          {children.map(child => (
            <PageTree key={child.id} page={child} pages={pages} />
          ))}
        </List.List>
      </List.Content>
    </List.Item>
  )
}

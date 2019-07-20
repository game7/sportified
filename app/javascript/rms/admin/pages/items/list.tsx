import React, { FC, useState, useEffect } from 'react'
import { RouteComponentProps, Link } from 'react-router-dom';
import { Item } from '../../data';
import { Card, Button } from 'semantic-ui-react';

interface Props extends RouteComponentProps<{}> {

}

type ViewName = 'active' | 'all'

const ItemsList : FC<Props> = () => {

  const [items, setItems] = useState<Item[]>([]);
  const [view, setView] = useState<ViewName>('active')

  useEffect(() => {
    fetch('/registrar/api/items')
      .then(response => response.json())
      .then<Item[]>(payload => payload.items as Item[])
      .then(items => {
        setItems(items)
      });
  }, [])

  const filtered = view == 'all' ? items : items.filter(item => !!item.active)

  return (
    <div>
      <div style={{ marginBottom: 15 }}>
        <Button.Group>
          <Button
            active={view == 'active'}
            onClick={() => setView('active')}
          >
            Active
          </Button>
          <Button
            active={view == 'all'}
            onClick={() => setView('all')}
          >
            All
          </Button>
        </Button.Group>
      </div>      
      {filtered.map(item => (
        <Card key={item.id} fluid>
          <Card.Content>
            <Card.Header>
              {item.title}
            </Card.Header>
            <Card.Description>
              {item.description}
            </Card.Description>
          </Card.Content>
          <Card.Content extra>
            <Link to={`/items/${item.id}`}>Dashboard</Link>
            {" | "}
            <Link to={`/items/${item.id}/registrations`}>Registrations</Link>
          </Card.Content>
        </Card>
      ))}
    </div>
  )

}

export default ItemsList

import * as React from 'react'
import { RouteComponentProps, Link } from 'react-router-dom';
import { Item } from '../../data';
import { Card } from 'semantic-ui-react';

interface Props extends RouteComponentProps<{}> {

}

interface State {
  items: Item[];
}

export default class ItemsList extends React.Component<Props,State> {

  componentWillMount() {
    this.setState({ items: [] }, () => {
      fetch('/registrar/api/items')
        .then(response => response.json())
        .then<Item[]>(payload => payload.items as Item[])
        .then(items => {
          this.setState({ items })
        });
    });
  }

  render() {
    const { items } = this.state;
    return (
      <div>
        {items.map(item => (
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

}

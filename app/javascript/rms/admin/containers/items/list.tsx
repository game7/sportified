import * as React from 'react'
import { RouteComponentProps, Link } from 'react-router-dom';
import { Item } from '../../data';

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
      <ul>
        {items.map(item => (
          <li key={item.id}>
            <Link to={`/items/${item.id}`} >{item.title}</Link> ({item.id})
          </li>
        ))}
      </ul>
    )

  }

}

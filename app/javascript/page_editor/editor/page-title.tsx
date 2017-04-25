import * as React from 'react'
import * as ReactDOM from 'react-dom';

interface PageTitleProps {
  title: string;
  onChange?: (newValue: string) => void;
}

export class PageTitle extends React.Component<PageTitleProps, {}> {

  private lastHtml = '';
  private element: HTMLHeadingElement;

  constructor() {
    super();
    this.emitChange = this.emitChange.bind(this);
  }

  componentWillUpdate(nextProps: PageTitleProps) {
    const element = ReactDOM.findDOMNode(this);
    if (nextProps.title !== element.innerHTML) {
        element.innerHTML = nextProps.title;
    }
  }

  shouldComponentUpdate(nextProps: PageTitleProps) {
    if (nextProps.title !== ReactDOM.findDOMNode(this).innerHTML) {
        return true;
    }
    return false; 
  }

  emitChange() {
    let element = ReactDOM.findDOMNode(this);
    const title = element.innerHTML;
    if (this.props.onChange && title !== this.lastHtml) {
        this.props.onChange(title);
    }
    this.lastHtml = title;
  }

  render() {
    return (
      <h1
        ref={(element) => { this.element = element }}
        contentEditable
        style={{ display: 'inline-block' }}
        onInput={this.emitChange}
        onBlur={this.emitChange}
        dangerouslySetInnerHTML={{ __html: this.props.title }}
      />
    );
  }

}

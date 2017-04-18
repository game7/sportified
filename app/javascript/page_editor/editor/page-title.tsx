import * as React from 'react'
import * as ReactDOM from 'react-dom';

interface PageTitleProps {
  title: string;
  onChange?: (newValue: string) => void;
}

export class PageTitle extends React.Component<PageTitleProps, {}> {

  private previous = '';
  private element: HTMLHeadingElement;

  constructor() {
    super();
    this.emitChange = this.emitChange.bind(this);
  }

  emitChange() {
    const title = this.element.innerText;
    if (this.props.onChange && title !== this.previous) {
        this.props.onChange(title);
    }
    this.previous = title;
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

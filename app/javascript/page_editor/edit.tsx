import * as React from 'react';
import { KeyboardEvent, MouseEvent, FormEvent } from 'react';
import { Spacer, Row, Col } from './common';
import { ButtonGroup, DefaultButton, PrimaryButton } from './common/buttons';
import { PageTitle } from './editor/page-title';
import { Editor } from './editor/editor';

interface IState {
  id: number;
  title: string;
  content: string;
  toc: string;
  html: string;
  viewName: string;
  dirty: boolean;
  saving: boolean;
  open: boolean;
  loading: boolean;
}

export class Edit extends React.Component<{},IState> {

  constructor() {
    super();
    [
      'handleViewChange',
      'handleTitleChange',
      'handleContentChange',
      'handleSave'
    ].forEach((fn) => { this[fn] = this[fn].bind(this) });
  }

  componentWillMount() {
    const { page }: any = Window['sportified'];
    const { id, title, content } = page;
    this.setState({
      id,
      title,
      content,
      viewName: 'MARKDOWN',
      loading: false
    });
  }

  handleContentChange(content: string) {
    this.setState({ content, dirty: true });
  }

  handleTitleChange(title: string) {
    this.setState({ title, dirty: true });
  }


  handleSave() {
    const { dirty, id, title, content } = this.state;
    var token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
    if(dirty) {
      fetch(`/pages/${id}`, {
        method: "PATCH",
        credentials: 'same-origin',
        body: JSON.stringify({ page: { title, content } }),
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token
        },
      }).then(() => this.setState((prev, props) => {
          return {
            ...prev,
            saving: false,
            dirty: false
          }
        }));
    }
  }

  handleViewChange(viewName: string) {
    const { content } = this.state;
    if(viewName == 'HTML') {
      if(content == '') {
        this.setState({
          viewName,
          html: ''
        })
      } else {
        fetch('/markdown', {
          method: "POST",
          body: JSON.stringify({ markdown: content }),
          headers: {
            "Content-Type": "application/json"
          },
        }).then(response => response.json() as any)
          .then(json => this.setState({
            viewName,
            html: json.html,
            toc: json.toc
          }));
      }
    } else {
      this.setState({ viewName });
    }
  }

  render() {
    const { title, content, html, toc, viewName } = this.state;
    return (
      <div>
        <div className="page-title clearfix">
          <PageTitle title={title} onChange={this.handleTitleChange}/>
          <div className="pull-right">
            <ButtonGroup>
              <DefaultButton
                icon="edit"
                label="Edit"
                active={this.state.viewName == 'MARKDOWN'}
                onClick={() => this.handleViewChange('MARKDOWN')}
              />
              <DefaultButton
                icon="eye"
                label="Preview"
                active={this.state.viewName == 'HTML'}
                onClick={() => this.handleViewChange('HTML')}
              />
            </ButtonGroup>
            <Spacer/>
            <PrimaryButton
              icon="save"
              label="Save"
              onClick={this.handleSave}
              disabled={!this.state.dirty}
            />
          </div>
        </div>
        <div style={{ display: viewName == 'MARKDOWN' ? 'block' : 'none' }}>
          <Editor onChange={this.handleContentChange} value={content}/>
        </div>
        <div style={{ display: viewName == 'HTML' ? 'block' : 'none' }} >
          <div dangerouslySetInnerHTML={{ __html: toc }} />
          <div dangerouslySetInnerHTML={{ __html: html }} />
        </div>
      </div>
    );
  }
}

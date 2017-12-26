import * as React from 'react';
import { Spacer, Row, Col } from './common';
import { ButtonGroup, DefaultButton, PrimaryButton } from './common/buttons';
import { debounce } from './common/utils';
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
      viewName: 'SPLIT',
      loading: false
    }, this.refreshPreview);
  }

  handleContentChange(content: string) {
    this.setState({ content, dirty: true }, this.refreshPreview);
  }

  refreshPreview = debounce(() => {
    const { content } = this.state;
    return fetch('/markdown', {
      method: "POST",
      body: JSON.stringify({ markdown: content }),
      headers: {
        "Content-Type": "application/json"
      },
    }).then(response => response.json() as any)
      .then(json => this.setState({
        html: json.html,
        toc: json.toc
      }));
  }, 500);

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
        this.setState({
            viewName
          }, this.refreshPreview);
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
                icon="columns"
                label="Split"
                active={this.state.viewName == 'SPLIT'}
                onClick={() => this.handleViewChange('SPLIT')}
              />
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
        <Row>
          <EditorPane viewName={viewName}>
            <Editor onChange={this.handleContentChange} value={content}/>
          </EditorPane>
          <PreviewPane viewName={viewName}>
            <div className="toc" dangerouslySetInnerHTML={{ __html: toc }} />
            <div dangerouslySetInnerHTML={{ __html: html }} />
          </PreviewPane>
        </Row>
      </div>
    );
  }
}

function includes(arr: any[], value: any) {
  return arr.indexOf(value) != -1;
}


const EditorPane = (props: { viewName: string, children?: any }) => {
  const css = props.viewName == 'MARKDOWN' ? 'col-sm-12' : 'col-sm-6';
  const visible = includes(['MARKDOWN','SPLIT'], props.viewName);
  const style = { display: visible ? 'block' : 'none' };
  return (
    <div className={css} style={style}>
      {props.children}
    </div>
  );
}

const PreviewPane = (props: { viewName: string, children?: any }) => {
  const css = props.viewName == 'HTML' ? 'col-sm-12' : 'col-sm-6';
  const visible = includes(['HTML','SPLIT'], props.viewName);
  const style = {
    display: visible ? 'block' : 'none',
    minHeight: '100%'
  };
  return (
    <div className={css} style={style}>
      <PreviewWrapper viewName={props.viewName}>
        {props.children}
      </PreviewWrapper>
    </div>
  );
}

const PreviewWrapper = (props: { viewName: string, children?: any }) => {
  const split = includes(['SPLIT'], props.viewName);
  const style = {
    border: split ? '1px solid #ccc' : '0',
    padding: split ? 3 : 0,
    marginTop: 40
  };
  return (
    <div style={style}>
      {props.children}
    </div>
  );
}

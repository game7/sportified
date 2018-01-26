import * as React from 'react';
import AceEditor from 'react-ace';
import 'brace/mode/markdown';
import 'brace/theme/chrome';
import { Toolbar, Snippet } from './toolbar';

interface IProps {
  value: string;
  onChange?: (value: string) => void
}

interface IState {
  editor: any;
}

export class Editor extends React.Component<IProps, IState> {

  constructor() {
    super();
    this.handleLoad = this.handleLoad.bind(this);
    this.insertSnippet = this.insertSnippet.bind(this);
  }

  handleLoad(editor: any) {
    editor.setShowInvisibles(true);
    this.setState({ editor });
  }

  insertSnippet(snippet: Snippet) {
    const { editor } = this.state;
    let selection = editor.getSelectedText() as string;
    if (selection == '' && snippet.content) { selection = snippet.content }
    const newline = snippet.newline && editor.selection.getRange().start != 0 ? '\n\n' : '';
    const tag = [newline, snippet.before, selection, snippet.after].join('');
    editor.session.replace(editor.selection.getRange(), tag)
    editor.focus();
  }

  render() {
    const { value, onChange } = this.props;
    return (
      <div>
        <Toolbar onAction={this.insertSnippet}/>
        <div style={{ border: "1px solid #ccc " }}>
          <AceEditor
            mode="markdown"
            theme="chrome"
            showGutter={false}
            showPrintMargin={false}
            wrapEnabled={true}
            width="100%"
            onChange={onChange}
            name="md-editor"
            value={value}
            onLoad={this.handleLoad}
          />
        </div>
      </div>
    );
  }

}

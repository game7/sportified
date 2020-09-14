import * as React from 'react';
import { Component } from 'react';
import { IImportState, Header, storage } from './common';
import { Input, Button } from 'semantic-ui-react';

export default class File extends Component<{},IImportState> {

  fileInput: any;

  componentWillMount() {
    const state = storage.load();
    this.setState(state);
  }

  handleFileSelect = (event) => {
    let file = event.target.files[0];
    if(file) {
      let reader = new FileReader();
      reader.onload = (e: any) => {
        this.setState({
          file: {
            name: file.name,
            content: e.target.result
          },
          delimiter: undefined,
          hasHeader: undefined,
          rows: undefined,
          columns: undefined,
          teamMaps: undefined,
          locationMaps: undefined
        }, () => storage.save(this.state));
      };
      reader.readAsText(file);
    }
  };

  handleStartOver = () => {
    this.setState({
      file: undefined,
      delimiter: undefined,
      hasHeader: undefined,
      rows: undefined,
      filename: undefined,
      columns: undefined
    }, () => storage.save(this.state));

  }

  get canMoveNext(): boolean {
    return !!this.state.file;
  }

  render() {
    return (
      <div>
        <Header
          title="File"
          canBack={false}
          canNext={this.canMoveNext}
          nextUrl="/games/data"
        />
        <div style={{display: 'none'}}>
          <input type="file"
            ref={(ref) => this.fileInput = ref}
            onChange={this.handleFileSelect}></input>
        </div>
        <Input type="text" action value={this.state.file ? this.state.file.name : ''}>
          <input />
          <Button content="Upload File" onClick={() => this.fileInput.click()}/>
        </Input>
        {this.state.file && (
          <pre style={{ minHeight: 100, padding: 10, border: '1px solid #dedede' }}>{this.state.file.content}</pre>
        )}
      </div>
    );
  }

}

import * as React from 'react';
import { Component } from 'react';
import { IImportState, Header, storage } from './common';

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
          canBack={true}
          backUrl="/games/import"
          canNext={this.canMoveNext}
          nextUrl="/games/import/data"
        />
        <div style={{display: 'none'}}>
          <input type="file"
            ref={(ref) => this.fileInput = ref}
            onChange={this.handleFileSelect}></input>
        </div>
        <div className="form-group">
          <button
            className="btn btn-default"
            onClick={() => this.fileInput.click()}>
            <i className="far fa-upload"/>
            {" "}Upload File
          </button>
          {" "}
          <button
            className="btn btn-default"
            style={{display: 'none'}}
            onClick={this.handleStartOver}>
            <i className="far fa-refresh"/>
            {" "}Start Over
          </button>
        </div>
        <div>
          <div className="form-group">
            <input className="form-control" disabled value={this.state.file ? this.state.file.name : ''} />
          </div>
          <pre style={{minHeight: 100}}>{this.state.file ? this.state.file.content : ''}</pre>
        </div>
      </div>
    );
  }

}

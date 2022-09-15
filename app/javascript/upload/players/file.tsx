import { useEffect, useRef, useState } from 'react';
import { Button, Input } from 'semantic-ui-react';
import { Header, storage } from './common';

export default function file() {
  const [state, setState] = useState(storage.load())

  useEffect(() => {
    storage.save(state)
  }, [state])

  const fileInputRef = useRef<HTMLInputElement>();

  function handleFileSelect(event) {
    let file = event.target.files[0];
    if (file) {
      let reader = new FileReader();
      reader.onload = (e: any) => {
        setState(state => ({
          ...state,
          file: {
            name: file.name,
            content: e.target.result
          },
          delimiter: undefined,
          hasHeader: undefined,
          rows: undefined,
          columns: undefined,
          teamMaps: undefined,
        }));
      };
      reader.readAsText(file);
    }
  };

  const canMoveNext = !!state.file;

  return (
    <div>
      <Header
        title="File"
        canBack={true}
        backUrl="/players"
        canNext={canMoveNext}
        nextUrl="/players/data"
      />
      <div style={{ display: 'none' }}>
        <input type="file"
          ref={fileInputRef}
          onChange={handleFileSelect}></input>
      </div>
      <Input type="text" action value={state.file ? state.file.name : ''}>
        <input />
        <Button content="Upload File" onClick={() => fileInputRef.current && fileInputRef.current.click()} />
      </Input>
      {state.file && (
        <pre style={{ minHeight: 100, padding: 10, border: '1px solid #dedede' }}>{state.file.content}</pre>
      )}
    </div>
  );

}

import React, { ReactElement, useState } from 'react'
import AceEditor from 'react-ace';
import 'brace/mode/markdown';
import 'brace/theme/chrome';
import { Menu, Segment, Dimmer, Loader, Image } from 'semantic-ui-react';

interface Props {
  object: string;
  attr: string;
  value: string;
  preview: string;
}

export const MarkdownEditor: (Props) => ReactElement = (props) => {
  const { object, attr } = props;

  const [value, setValue] = useState(props.value)
  const [preview, setPreview] = useState(props.preview)
  const [loading, setLoading] = useState(false);
  const [tab, setTab] = useState('edit')
  function handleChange(newValue) {
    setValue(newValue)
    setPreview(null)
  }

  async function fetchPreview() {
    if(!preview) {
      setLoading(true);
      const response = await fetch('/markdown', {
        method: 'POST',
        body: JSON.stringify({
          markdown: value
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
      })
      const json = (await response.json()) as { html: string }
      setTimeout(() => {
        setPreview(json.html)
        setLoading(false);        
      }, 2000);

    }
  }

  return (
    <React.Fragment>
      <input type="hidden" name={`${object}[${attr}]`} value={value} />
      <Menu attached='top' tabular>
        <Menu.Item name="edit" active={tab === 'edit'} onClick={() => setTab('edit') } />
        <Menu.Item name="preview" active={tab === 'preview'} onClick={() => setTab('preview') } onMouseOver={fetchPreview} />
      </Menu>
      <Segment attached='bottom' loading={tab === 'preview' && loading}>
        {tab === 'edit' && (
          <AceEditor
            mode="markdown"
            theme="textmate"
            showGutter={false}
            showPrintMargin={false}
            wrapEnabled={true}
            width="100%"
            onChange={handleChange}
            name="md-editor"
            value={value}
            // onLoad={this.handleLoad}
          />
        )}
        {tab === 'preview' && !loading && (
          <div dangerouslySetInnerHTML={{ __html: preview }} />
        )}
        {tab === 'preview' && loading && (
          <Image src="/paragraph.png" />
        )}        

      </Segment>
    </React.Fragment>
  )
}

export default MarkdownEditor
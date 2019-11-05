import React, { FC, useState, useEffect } from 'react'
import { Grid, Button, Dropdown, Segment } from "semantic-ui-react"
import { preview } from '../actions/posts'

interface Props {
  content?: string
  onChange?: (event: React.ChangeEvent<HTMLTextAreaElement>) => void
  onPreview?: (content: string) => Promise<string>
  rows?: number
}

type View = 'edit' | 'preview'

export const MarkdownEditor: FC<Props> = (props) => {
  const {
    onChange = () => {},
    rows = 10,
    onPreview
  } = props;
  const [ view, setView ] = useState<View>('edit')
  const [ loading, setLoading ] = useState(false)
  const [ content, setContent ] = useState(props.content || "")
  const [ preview, setPreview ] = useState("")
  const control = React.createRef<HTMLTextAreaElement>();

  useEffect(() => {
    if(view === "preview" && onPreview) {
      setLoading(true)
      onPreview(content).then(preview => {
        setPreview(preview)
        setLoading(false)
      })
    }
  }, [ view ])

  function handleChange(event: React.ChangeEvent<HTMLTextAreaElement>) {
    setContent(event.target.value)
    onChange && onChange(event)
  }

  function handlePaste(event: React.ClipboardEvent<HTMLTextAreaElement>) {

    const text = event.clipboardData.getData('text/plain');
    const match = /[\n\u0085\u2028\u2029]|\r\n?/g;
    const rows = text.split(match).filter(row => row !== "").map(row => row.split('\t'))
    if(rows.length <= 1) {
      return
    } else {
      event.preventDefault()
    }
    const widths = rows.map(cols => cols.map(col => col.length)).reduce((result, cols) => {
      return cols.map((col, i) => Math.max(result[i], col))
    })
    const md = rows.map(cells => {
      return cells.reduce((row, cell, i) => {
        return `${row} ${cell} ${' '.repeat(widths[i] - cell.length)}|`
      }, "|")
    })
    const separator = `|-${widths.map(col => '-'.repeat(col)).join('-|-')}-|`
    const [header, ...remaining] = md;
    const result = [
      header,
      separator,
      ...remaining
    ].join('\n')
    event.clipboardData.setData('text/plain', result)
    const [start] = selection();
    setContent(insertAt(content, [result, start]))
  }

  function selection(): [number, number] {
    return [
      (control.current && control.current.selectionStart) || 0,
      (control.current && control.current.selectionEnd) || 0
    ]
  }

  function insertAt(content: string, ...insertions: [string, number][]) {
    return insertions.reduce((result, insert) => {
      console.log(result)
      const [str, position] = insert;
      return [result.slice(0, position), str, result.slice(position)].join('')
    }, content)
  }

  function wrap(content: string, using: string, andAlso?: string) {
    let [start, end] = selection();
    if(end > 0 && content.charAt(end - 1) == ' ') { end-- }
    const result = insertAt(content, [andAlso || using, end], [using, start]);
    setContent(result)
  }

  function italicize() {
    wrap(content, '_')
  }

  function embolden() {
    wrap(content, '**')
  }

  function strikethrough() {
    wrap(content, '~~')
  }

  function linkify() {
    wrap(content, '[', '](url)')
  }

  function headerize(using: number) {
    return function() {
      const [start, end] = selection()
      const position = content.lastIndexOf('\n', start) + 1
      console.log(start, end, position)
      const insert = '#'.repeat(using) + ' '
      setContent(insertAt(content, [insert, position] ))
    }
  }

  return (
    <React.Fragment>
      <Grid style={{ marginBottom: 10 }}>
        <Grid.Row style={{ paddingBottom: 2 }}>
          <Grid.Column width="12">
            <Button.Group>
              <Dropdown button icon="heading">
                <Dropdown.Menu>
                  <Dropdown.Item content="Heading 1" onClick={headerize(1)} />
                  <Dropdown.Item content="Heading 2" onClick={headerize(2)} />
                  <Dropdown.Item content="Heading 3" onClick={headerize(3)} />
                  <Dropdown.Item content="Heading 4" onClick={headerize(4)} />
                  <Dropdown.Item content="Heading 5" onClick={headerize(5)} />
                </Dropdown.Menu>
              </Dropdown>
              <Button icon="bold" onClick={embolden} />
              <Button icon="italic" onClick={italicize} />
              <Button icon="strikethrough" onClick={strikethrough} />
            </Button.Group>
            {' '}
            <Button.Group>
              <Button icon="linkify" onClick={linkify} />
              <Button icon="quote right"/>
              <Button icon="code"/>
              <Button icon="image"/>
              <Button icon="horizontal rule"/>
            </Button.Group>
            {' '}
            <Button.Group>
              <Button icon="list"/>
              <Button icon="list ol"/>
            </Button.Group>
          </Grid.Column>
          <Grid.Column width="4" textAlign="right">
            <Button.Group>
              <Button content="Edit" active={view === 'edit'} onClick={() => setView('edit') }/>
              <Button content="Preview" active={view === 'preview'} onClick={() => setView('preview') }/>
            </Button.Group>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row style={{ paddingTop: 0}}>
          <Grid.Column width="16">
            {view === "edit" && (
              <textarea
                ref={control}
                value={content}
                onChange={handleChange}
                onPaste={handlePaste}
                style={{ fontFamily: 'monospace' }}
              />
            )}
            {view === "preview" && (
              <Segment dangerouslySetInnerHTML={{ __html: preview }}></Segment>
            )}
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </React.Fragment>
  )
}

export default MarkdownEditor;

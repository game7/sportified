import React, { FC, useState, useCallback, useRef } from 'react';
import Dropzone from 'react-dropzone'
import ReactAvatarEditor from 'react-avatar-editor'
import { Button, Modal } from 'semantic-ui-react'

interface AvatarEditorProps {
  onChange: (canvas: HTMLCanvasElement) => void
}

const AvatarEditor: FC<AvatarEditorProps> = ({ onChange }) => {
  const [open, setOpen] = useState()
  const [file, setFile] = useState();
  const [scale, setScale] = useState(1);
  const editor = useRef(null);
  const onDrop = useCallback(acceptedFiles => {
    setFile(acceptedFiles[0])
  }, [])

  const style = {
    flex: 1,
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    padding: 20,
    borderWidth: 2,
    borderRadius: 2,
    borderColor: '#eeeeee',
    borderStyle: 'dashed',
    backgroundColor: '#fafafa',
    color:'#bdbdbd',
    outline: 'none',
    transition: 'border .24s ease-in-out',
    width: 250,
    height: 250
  } as React.CSSProperties

  function zoom(increment: number) {
    setScale(scale + (increment * .1))
  }

  function zoomIn() {
    zoom(1)
  }

  function zoomOut() {
    zoom(-1)
  }

  function handleOpen() {
    setOpen(true)
    setFile(null)
    setScale(1)
  }

  function handleClose() {
    setOpen(false)
  }

  function useLogo() {
    onChange(editor.current.getImage())
    setOpen(false)
  }

  function close() {
    setOpen(false)
  }

  const trigger = (
    <Button fluid onClick={(e) => { e.preventDefault() }}>Change Avatar</Button>
  )

  return (
    <Modal open={open} trigger={trigger} centered={false} size="tiny" onOpen={handleOpen} onClose={handleClose}>
      <Modal.Header>Set Avatar</Modal.Header>
      <Modal.Content>
        {!file && (
          <Dropzone onDrop={onDrop}>
            {({getRootProps, getInputProps}) => (
              <section className="container">
                <div {...getRootProps({ style, accept: ['.jp  '], multiple: false })}>
                  <input {...getInputProps()} />
                  <p>Drag 'n' drop an image here or click to select one</p>
                </div>
              </section>
            )}
          </Dropzone>
        )}
        {file && (
          <React.Fragment>
            <ReactAvatarEditor
              ref={editor}
              image={file}
              width={250}
              height={250}
              scale={scale}
              style={{ display: 'block', marginBottom: 5 }}
            />
            <Button.Group>
              <Button icon="zoom in" onClick={zoomIn} />
              <Button icon="zoom out" onClick={zoomOut} />
            </Button.Group>
          </React.Fragment>
        )}
      </Modal.Content>
      <Modal.Actions>
        <Button onClick={useLogo} primary disabled={!file}>Use Logo</Button>
        <Button onClick={close}>Cancel</Button>
      </Modal.Actions>
    </Modal>
  )
}

export default AvatarEditor;


import React, { FC, useEffect, useState, useRef } from 'react';
import { Divider, Button, Modal, Form, Grid, Icon, Card, Image as SemanticImage } from 'semantic-ui-react';
import * as ReactAvatarEditor from 'react-avatar-editor';
import './react-image-crop.css';
import ColorThief from 'colorthief'
import { ColorPicker } from './color-picker';

function numberToHex(n: number) {
  var hex = n.toString(16);
  return hex.length == 1 ? "0" + hex : hex;
}
function rgbToHex(color: [number, number, number]) {
  return "#" + numberToHex(color[0]) + numberToHex(color[1]) + numberToHex(color[2]);
}

interface Props {
  object: any;
  klass: string;
  url: string;
  primaryColor: string;
  secondaryColor: string;
  accentColor: string;
}

interface Colors {
  primary: string;
  secondary: string;
  accent: string;
}

const AvatarEditor: FC<Props> = ({ object, url, primaryColor, secondaryColor, accentColor }) => {

  // state
  const [open, setOpen] = useState(false)
  const [file, setFile] = useState<string>()
  const [preview, setPreview] = useState<string>()
  const [palette, setPalette] = useState<string[]>([])
  const [scale, setScale] = useState<number>()
  const [colors, setColors] = useState<Colors>({
    primary: primaryColor,
    secondary: secondaryColor,
    accent: accentColor
  })

  // refs
  const imageRef = useRef<HTMLImageElement>();
  const editorRef = useRef<ReactAvatarEditor>();

  function handleOpen() {
    setFile(null)
    setOpen(true)
  }

  function handleClose(e = null) {
    setOpen(false)
  }  

  function handleScale(e) {
    setScale(parseFloat(e.target.value))
  }

  function handlePreview() {
    const canvas: HTMLCanvasElement = editorRef.current.getImageScaledToCanvas()
    setPreview(canvas.toDataURL())
    handleClose()
  }

  function onSelectFile(e: React.ChangeEvent<HTMLInputElement>){
    if (e.target.files && e.target.files.length > 0) {
      const reader = new FileReader();
      reader.addEventListener('load', () => {
        setFile(reader.result.toString())
      });
      reader.readAsDataURL(e.target.files[0]);
    }
  };

  function colorChange(key: keyof Colors) {
    return function handleColorChange(color: string) {
      setColors((colors) => ({
        ...colors,
        [key]: color
      }))
    }
  }

  useEffect(function getPalette() {
    if(imageRef.current) {
      let image = new Image();
      image.crossOrigin = "Anonymous"
      image.addEventListener("load", function imageLoaded() {
        const colors = new Set(new ColorThief().getPalette(image).map(rgbToHex) as string[])
        colors.add('#000000').add('#ffffff');
        setPalette(Array.from(colors))
      }, false);
      image.src = imageRef.current.src
    }
  }, [url, preview])

  const trigger = (
    <Button fluid onClick={(e) => { e.preventDefault() }}>Change Avatar</Button>
  )

  return (
    <React.Fragment>
      <div style={{ display: 'flex', flexDirection: 'column', marginBottom: 10 }} >
        <img src={preview || url} style={{ margin: 'auto' }} ref={imageRef} />
      </div>
      { preview && (
        <input type="hidden" name={`${object}[logo]`} value={preview} />
      )}
      <Modal open={open} trigger={trigger} centered={false} size="tiny" onOpen={handleOpen} onClose={handleClose}>
        <Modal.Header>Set Avatar</Modal.Header>
        <Modal.Content>
          <Form>
            <input type="file" accept="image/*" onChange={onSelectFile} />
          </Form>
          {file && (
            <React.Fragment>
              <div style={{ marginTop: 20, display: 'flex', flexDirection: 'column' }}>
                <div style={{ margin: 'auto' }}>
                  <ReactAvatarEditor 
                    ref={editorRef}
                    image={file}
                    width={200}
                    height={200}
                    scale={scale} 
                  />
                </div>
                <div style={{ margin: 'auto', marginTop: 10 }}>
                  <Icon name="zoom out" />
                  <input
                    name="scale"
                    type="range"
                    onChange={handleScale}
                    min="1"
                    max="2"
                    step="0.01"
                    defaultValue="1"
                  />  
                  <Icon name="zoom in" />
                </div>
              </div>
            
            </React.Fragment>
          )}

        </Modal.Content>
        <Modal.Actions>
          <Button content="Use Avatar" disabled={!file} primary onClick={handlePreview} />
          <Button content="Cancel" onClick={handleClose} />
        </Modal.Actions>
      </Modal>
      <Card fluid>
        <Card.Content style={{ backgroundColor: colors.primary, color: colors.secondary }}>
          <SemanticImage src={ preview || url || '/image.png' } size='mini' rounded floated="left" style={{ marginBottom: 0 }} />
          <Card.Header style={{ color:  colors.secondary }}>Team Name</Card.Header>
          <Card.Meta  style={{ color:  colors.accent }}>blah, blah, blah</Card.Meta>
        </Card.Content>
        <Card.Content extra>
          <ColorPicker value={colors.primary} palette={palette} onChange={colorChange('primary')}>Main</ColorPicker>
          <ColorPicker value={colors.secondary} palette={palette} onChange={colorChange('secondary')}>Title</ColorPicker>
          <ColorPicker value={colors.accent} palette={palette} onChange={colorChange('accent')}>Text</ColorPicker>
        </Card.Content>
      </Card>
      <input type="hidden" name={`${object}[primary_color]`} value={colors.primary} />
      <input type="hidden" name={`${object}[secondary_color]`} value={colors.secondary} />
      <input type="hidden" name={`${object}[accent_color]`} value={colors.accent} />
    </React.Fragment>
  )
}

export default AvatarEditor;
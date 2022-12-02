import React, { FC, useState, useRef, useCallback } from 'react'
import { Button, Modal, Divider } from 'semantic-ui-react'
import ReactImageCrop, { Crop } from 'react-image-crop';
import './react-image-crop.css';

interface Props {
  onChange?: (canvas: HTMLCanvasElement) => void
}

export const AvatarEditor: FC<Props> = (props) => {
  const { onChange = function() {} } = props;
  const [open, setOpen] = useState(true)
  const [imageUrl, setImageUrl] = useState<string>();
  const [croppedImageUrl, setCroppedImageUrl] = useState();

  const [crop, setCrop] = useState<Crop>({
    unit: '%',
    width: 100,
    aspect: 1
  })

  function onSelectFile(e){
    if (e.target.files && e.target.files.length > 0) {
      const reader = new FileReader();
      reader.addEventListener('load', () => {
        setImageUrl(reader.result.toString())
      });
      reader.readAsDataURL(e.target.files[0]);
    }
  };

  function onCropChange(crop: Crop) {
    setCrop(crop)
  }

  async function onCropComplete(crop: Crop) {
    const imgElement = new Image();
    imgElement.src = imageUrl;
    setCroppedImageUrl(await getCroppedImage(imgElement, crop, 'booyah'))
  }

  async function getCroppedImage(image, crop: Crop, filename: string) {
    /*

      original: 900,  900
      editor: 400,  400
      editor_scale: 400 / 900, 400 / 900
      cropper: 200, 200
      cropper_scale: 200 / 400, 200 / 400



    */
    console.log(image.width, image.height, image.naturalWidth, image.naturalHeight)
    const { height, width } = image;
    
    const original = [width, height]
    const editor = [400, 400]
    const editorScale = [(editor[0] / original[0]), (editor[1] / original[1])];
    const cropper = [crop.width, crop.height]
    const cropperScale = [(cropper[0] / editor[0]), (cropper[1] / editor[1])];

    const canvas = document.createElement('canvas');
    const scaleX = crop.width / 400;
    const scaleY = crop.height / 400;
    canvas.width = crop.width;
    canvas.height = crop.height;
    console.log('--------------------------------------------------------')
    console.log('editor:', editorScale)
    console.log('cropper:', cropperScale)
    // console.log('orign: ', original)
    // console.log('crop: ', [crop.width, crop.height])
    // console.log('scale: ', scale)
    // console.log('grab: ', crop.width / scale[0], crop.height / scale[1])
    // console.log('pos: ', crop.x / scale[0], crop.y / scale[1])
    // console.log('size: ', crop.width / scale[0],crop.height / scale[1])
    // console.log('pos: ', crop.x * -1, crop.y * -1)

    const ctx = canvas.getContext('2d');
    ctx.drawImage(
      image,
      crop.x / editorScale[0],
      crop.y / editorScale[1],
      crop.width / editorScale[0] / cropperScale[0],
      crop.height / editorScale[1] / cropperScale[1],
      0,
      0,
      400,
      400
    );

    return new Promise((resolve, reject) => {
      canvas.toBlob(blob => {
        if (!blob) {
          //reject(new Error('Canvas is empty'));
          console.error('Canvas is empty');
          return;
        }
        blob['name'] = filename;
        window.URL.revokeObjectURL(croppedImageUrl);
        const url = window.URL.createObjectURL(blob)
        resolve(url);
      }, 'image/jpeg');
    });    
  }

  function handleOpen() {
    setOpen(true)
    setImageUrl(null)
    setCroppedImageUrl(null)
  }

  function handleClose() {
    setOpen(false)
  }

  function useLogo() {
    //onChange(editor.current.getImageScaledToCanvas())
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
        <div>
          <input type="file" accept="image/*" onChange={onSelectFile} />
        </div>
        {imageUrl && (
          <React.Fragment>
            <Divider />
            <ReactImageCrop
              src={imageUrl}
              crop={crop}
              // ruleOfThirds
              onComplete={onCropComplete}
              onChange={onCropChange}
              style={{
                maxWidth: 400,
                maxHeight: 400
              }}
            />
          </React.Fragment>
        )}    
        {croppedImageUrl && (
          <div>
            <img alt="Crop" style={{ maxWidth: '100%', border: '1px solid gray', height: 400, width: 400 }} src={croppedImageUrl} />
          </div>
        )}            
        {/* {!file && (
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
        )} */}
        {/* {file && (
          <React.Fragment>
            <ReactAvatarEditor
              ref={editor}
              image={file}
              width={200}
              height={200}
              scale={scale}
              style={{ display: 'block', marginBottom: 5 }}
            />
            <Button.Group>
              <Button icon="zoom in" onClick={zoomIn} />
              <Button icon="zoom out" onClick={zoomOut} />
            </Button.Group>
            {scale}
            <hr/>
            {editor.current && (
              <img src={editor.current.getImageScaledToCanvas().toDataURL()} />
            )}
          </React.Fragment>
        )} */}
      </Modal.Content>
      <Modal.Actions>
        <Button onClick={useLogo} primary disabled={!imageUrl}>Use Logo</Button>
        <Button onClick={close}>Cancel</Button>
      </Modal.Actions>
    </Modal>
  )
}
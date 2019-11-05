import React, { FC, useState, useRef, useEffect } from 'react';
import { Form, Grid, Header } from 'semantic-ui-react';
import { Team } from '../../actions/teams';
import AvatarEditor from '../../components/avatar-editor'
import ColorPicker from '../../components/color-picker'
import { Card, Image, Label, Button } from 'semantic-ui-react'
import ColorThief from 'colorthief'

interface TeamFormProps {
  data?: Partial<Team>
  avatarUrl?: string
  loading?: boolean
  onChange?: (data: Partial<Team>) => void
  onSubmit: (data: Partial<Team>, setErrors: (errors: any) => void) => void
}

function numberToHex(n: number) {
  var hex = n.toString(16);
  return hex.length == 1 ? "0" + hex : hex;
}

function rgbToHex(color: [number, number, number]) {
  return "#" + numberToHex(color[0]) + numberToHex(color[1]) + numberToHex(color[2]);
}

const TeamForm: FC<TeamFormProps> = (props) => {
  const {
    data,
    avatarUrl,
    onSubmit = () => {},
    onChange = () => {},
    loading = false
  } = props
  const [avatar, setAvatar] = useState(avatarUrl || '/image.png')
  const [palette, setPalette] = useState<string[]>([])
  const [errors, setErrors] = useState({})
  const imageRef = useRef(null);

  useEffect(function getPalette() {
    if(avatar && imageRef.current) {
      // add a slight delay since Rails Active Storage may perform
      // a redirect during the loading of the image
      setTimeout(function() {
        const palette = new ColorThief().getPalette(imageRef.current).map(rgbToHex) as string[];
        const [BLACK, WHITE] = ['#000000', '#ffffff']
        if(!palette.find(color => color === BLACK)) { palette.push(BLACK) }
        if(!palette.find(color => color === WHITE)) { palette.push(WHITE) }
        setPalette(palette)
      }, 1000)
    }
  }, [ avatar ])

  function bind(attr: keyof Team) {
    return function(event: React.ChangeEvent<HTMLInputElement> | React.ChangeEvent<HTMLTextAreaElement>) {
      onChange({
        ...data,
        [attr]: event.target.value
      })
    }
  }

  function handleSubmit() {
    onSubmit(data, setErrors)
  }

  function handleAvatarChange(canvas: HTMLCanvasElement) {
    const avatar = canvas.toDataURL()
    setAvatar(avatar)
    onChange({
      ...data,
      avatar: {
        data: avatar
      }
    })
  }

  function bindColor(attr: string) {
    return function(color: string) {
      onChange({
        ...data,
        [attr]: color
      })
    }
  }

  function bindCheckbox(attr:string) {
    return function(e: React.FormEvent<HTMLInputElement>) {
      onChange({
        ...data,
        [attr]: e.target['value']
      })
    }
  }
  console.log(data)
  return (
    <Form onSubmit={handleSubmit} loading={loading}>
      <Grid>
        <Grid.Row>
          <Grid.Column width="10">
            <Form.Input label="Name" onChange={bind('name')} error={errors['name']} value={data.name} />
            <Form.Input label="Short Name" onChange={bind('shortName')} error={errors['shortName']} value={data.shortName} />
            <Form.Checkbox label="Show In Standings" onChange={bindCheckbox('showInStandings')} error={errors['showInStandings']} checked={data.showInStandings} />
            <Form.Button type="submit">Save Changes</Form.Button>
          </Grid.Column>
          <Grid.Column width="6">
            <Card>
              <img className="ui image" src={avatar} ref={imageRef} />
              <Card.Content extra>
                <AvatarEditor onChange={handleAvatarChange} />
              </Card.Content>
            </Card>
            <Card>
              <Card.Content style={{ backgroundColor: data.primaryColor, color: data.secondaryColor }}>
                <Image src={ avatar || '/image.png' } size='mini' rounded floated="left" style={{ marginBottom: 0 }} />
                <Card.Header style={{ color: data.secondaryColor }}>{data.name}</Card.Header>
                <Card.Meta  style={{ color: data.accentColor }}>blah, blah, blah</Card.Meta>
              </Card.Content>
              <Card.Content extra>
                <ColorPicker value={data.primaryColor} palette={palette} onChange={bindColor("primaryColor")}>Main</ColorPicker>
                <ColorPicker value={data.secondaryColor} palette={palette} onChange={bindColor("secondaryColor")}>Title</ColorPicker>
                <ColorPicker value={data.accentColor} palette={palette} onChange={bindColor("accentColor")}>Text</ColorPicker>
              </Card.Content>
            </Card>
          </Grid.Column>
        </Grid.Row>
      </Grid>

    </Form>
  )
}

export default TeamForm

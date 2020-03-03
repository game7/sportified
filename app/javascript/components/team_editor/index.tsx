import React, { FC, useState, useEffect, useRef } from 'react';
import { Form, Grid, Card, Image } from 'semantic-ui-react';
import { Team, Season, Division, Club } from '../common/types';
import { useForm } from '../common/hooks';
import { AvatarEditor } from './avatar-editor';
import { ColorPicker } from './color-picker';
import ColorThief from 'colorthief';
import { omit } from 'lodash';

interface Props {
  team: Team,
  options: {
    seasons: Season[],
    divisions: Division[],
    clubs: Club[]
  }
}

function numberToHex(n: number) {
  var hex = n.toString(16);
  return hex.length == 1 ? "0" + hex : hex;
}

function rgbToHex(color: [number, number, number]) {
  return "#" + numberToHex(color[0]) + numberToHex(color[1]) + numberToHex(color[2]);
}

const TeamEditor: FC<Props> = ({team, options}) => {

  async function handleSubmit(model, setErrors) {
    const url = team.url;
    const method = 'PATCH';
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const body = JSON.stringify({ team: model })
    const response = await fetch(url, { method, headers, body })
    if(response.status == 422) {
      setErrors((await response.json()).messages)
    } else {
      const game = await response.json();
      window.location.replace(document.referrer);
    }
  }

  const [avatar, setAvatar] = useState('/image.png')
  const [palette, setPalette] = useState<string[]>([])
  const form = useForm(omit(team, 'logo'), handleSubmit);
  const imageRef = useRef(null);

  const seasonOptions = options.seasons.map(item => ({ value: item.id, text: item.name }))
  const divisionOptions = options.divisions.map(item => ({ value: item.id, text: item.name }))
  const clubOptions = options.clubs.map(item => ({ value: item.id, text: item.name }))

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

  function handleAvatarChange(canvas: HTMLCanvasElement) {
    const avatar = canvas.toDataURL();
    setAvatar(avatar)
  }

  function formColor(attr: string) {
    return function(color: string) {
      form.setModel(model => ({
        ...model,
        [attr]: color
      }))
    }
  }  

  return (
    <React.Fragment>
      <Form {...form.form}>
        <Grid>
          <Grid.Column width="10">
            <Form.Group widths="2">
              <Form.Select {...form.input('seasonId')} label="Season" options={seasonOptions} required />
              <Form.Select {...form.input('divisionId')} label="Division" options={divisionOptions} required />
            </Form.Group>
            <Form.Input {...form.input('name')} required width="8" />
            <Form.Input {...form.input('shortName')} width="4" />
            <Form.Select {...form.input('clubId')} label="Club" options={clubOptions} width="4" />
            <Form.Group>
              <Form.Input {...form.input('pool')} width="2" />
              <Form.Input {...form.input('seed')} width="2" />
            </Form.Group>
            <Form.Button onClick={form.submit} content="Update Team" />
          </Grid.Column>
          <Grid.Column width="6">
            <Card>
              <Image src={avatar} ref={imageRef} wrapped ui={false} />
              <Card.Content extra>
                <AvatarEditor onChange={handleAvatarChange} />
              </Card.Content>
            </Card>
            <Card>
              <Card.Content style={{ backgroundColor: form.model.primaryColor, color: form.model.secondaryColor }}>
                <Image src={ avatar || '/image.png' } size='mini' rounded floated="left" style={{ marginBottom: 0 }} />
                <Card.Header style={{ color:  form.model.secondaryColor }}>{ form.model.name}</Card.Header>
                <Card.Meta  style={{ color:  form.model.accentColor }}>blah, blah, blah</Card.Meta>
              </Card.Content>
              <Card.Content extra>
                <ColorPicker value={form.model.primaryColor} palette={palette} onChange={formColor("primaryColor")}>Main</ColorPicker>
                <ColorPicker value={form.model.secondaryColor} palette={palette} onChange={formColor("secondaryColor")}>Title</ColorPicker>
                <ColorPicker value={form.model.accentColor} palette={palette} onChange={formColor("accentColor")}>Text</ColorPicker>
              </Card.Content>
            </Card>
          </Grid.Column>
        </Grid>
      </Form>
      <pre>{JSON.stringify(palette, null, 2)}</pre>
    </React.Fragment>
  )

}

export default TeamEditor;
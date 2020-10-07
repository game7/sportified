import React, { FC, useState } from 'react';
import { Settings, Player, Team, Goaltender, Action } from '../../common/types';
import { Button, Modal, Form, Dropdown } from 'semantic-ui-react'
import { useForm } from '../../common/hooks';
import { omit, sortBy } from 'lodash'

type Mode = "new" | "edit";

interface GoaltenderEditorProps {
  settings: Settings;
  teams: Team[];
  players: Player[];  
  goaltender?: Goaltender;
  dispatch: React.Dispatch<Action>
}

export const GoaltenderEditor: FC<GoaltenderEditorProps> = ({ settings, goaltender, players, teams, dispatch }) => {

  const model = goaltender ? omit(goaltender, "createdAt", "updatedAt") : { };

  function reset() {
    form.setModel(model);
    form.setErrors({});
  }

  function handleOpen() {
    reset()
    setOpen(true);
  }

  function handleClose() {
    reset()
    setOpen(false);
  }

  const [infractions, setInfractions] = useState([
    "Butt ending",
    "Checking from behind",
    "Cross-checking",
    "Delay of game",
    "Elbowing",
    "Fighting",
    "Holding",
    "Hooking",
    "Interference",
    "Kneeing",
    "Roughing",
    "Slashing",
    "Spearing",
    "Tripping",
    "Unsportsmanlike conduct",
    "Misconduct",
    "Game misconduct",
    "Too many men",
    "High stick",
    "Bench minor"
  ])

  async function handleSubmit(model: Goaltender, setErrors) {
    const url = goaltender ? `/admin/hockey_statsheets/${settings.id}/goaltenders/${model.id}` : `/admin/hockey_statsheets/${settings.id}/goaltenders`
    const method = goaltender ? 'PATCH' : 'POST'
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const body = JSON.stringify({ hockey_goaltender_result: { teamId: "", ...model }})
    const response = await fetch(url, { method, headers, body })
    if(response.status == 422) {
      setErrors((await response.json()).messages)
    } else {
      const type = goaltender ? 'goaltender/updated' : 'goaltender/created'
      const payload = await response.json();
      dispatch({ type, payload });
      handleClose();
    }
  }

  const [open, setOpen] = useState(false)
  const form = useForm<Goaltender>(model, handleSubmit)
  const trigger = (<Button primary content={goaltender ? "Edit" : "Add Goaltender"} size={goaltender ? "mini" : "medium"} onClick={handleOpen} />);

  const playerOptions = sortBy(players.filter(p => p.teamId == form.model.teamId).map(p => ({ text: `${p.jerseyNumber} - ${p.lastName}, ${p.firstName}`, value: p.id })), "text")

  return (
    <Modal trigger={trigger} onClose={handleClose} open={open} size="mini">
      <Modal.Header>{goaltender ? 'Edit Goaltender' : 'New Goaltender'}</Modal.Header>
      <Modal.Content>
        <Form {...form.form()}>
          <Form.Field 
            control="select"
            {...form.input('teamId', { errorKey: 'team' })} 
            label="Team" 
            required 
            autoFocus={!goaltender}
            options={teams.map(t => ({ text: t.name, value: t.id }))} 
          >
            <React.Fragment>
              <option></option>
              {teams.map(t => (<option key={t.id} value={t.id}>{t.name}</option>))}
            </React.Fragment>
          </Form.Field>
          <Form.Field 
            control="select"
            {...form.input('playerId', { errorKey: 'player' })}             
            label="Player" 
            options={playerOptions} 
          >
            <React.Fragment>
              <option></option>
              {playerOptions.map(o => (<option key={o.value} value={o.value}>{o.text}</option>))}
            </React.Fragment>
          </Form.Field>
          <Form.Group widths="3">
            <Form.Input 
              {...form.input('minutesPlayed')} 
              autoFocus={goaltender}
            />                      
            <Form.Input 
              {...form.input('shotsAgainst')} 
            />
            <Form.Input 
              {...form.input('goalsAgainst')} 
            />
          </Form.Group>          
        </Form>
      </Modal.Content>
      <Modal.Actions>
        <Button primary content="Save Goaltender" onClick={form.submit} />
      </Modal.Actions>
    </Modal>
  )
}

import React, { FC, useState } from 'react';
import { Settings, Skater, Team, Penalty, Action } from '../../common/types';
import { Button, Modal, Form, Dropdown } from 'semantic-ui-react'
import { useForm } from '../../common/hooks';
import { omit } from 'lodash'

type Mode = "new" | "edit";

interface PenaltyEditorProps {
  settings: Settings;
  teams: Team[];
  skaters: Skater[];  
  penalty?: Penalty;
  dispatch: React.Dispatch<Action>
}

export const PenaltyEditor: FC<PenaltyEditorProps> = ({ settings, penalty, skaters, teams, dispatch }) => {

  const model = penalty ? omit(penalty, "createdAt", "updatedAt") : {
    infraction: "",
    severity: ""
  };
  
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

  async function handleSubmit(model: Penalty, setErrors) {
    const url = penalty ? `/admin/hockey_statsheets/${settings.id}/penalties/${model.id}` : `/admin/hockey_statsheets/${settings.id}/penalties`
    const method = penalty ? 'PATCH' : 'POST'
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const body = JSON.stringify({ hockey_penalty: { ...model }})
    const response = await fetch(url, { method, headers, body })
    if(response.status == 422) {
      setErrors((await response.json()).messages)
    } else {
      const type = penalty ? 'penalty/updated' : 'penalty/created'
      const payload = await response.json();
      dispatch({ type, payload });
      handleClose();
    }
  }

  function handleAddInfraction(_event, { value }) {
    setInfractions(infractions => [...infractions, value])
  }

  const [open, setOpen] = useState(false)
  const form = useForm<Penalty>(model, handleSubmit)
  const trigger = (<Button primary content={penalty ? "Edit" : "Add Penalty"} size={penalty ? "mini" : "medium"} onClick={handleOpen} />);

  const skaterOptions = skaters.filter(p => p.teamId === form.model.teamId).map(p => ({ text: `${p.jerseyNumber} - ${p.lastName}, ${p.firstName}`, value: p.id }))
  const infractionOptions = infractions.map(str => ({ text: str, value: str }))
  const severityOptions = [
    "Minor",
    "Major",
    "Misconduct",
    "Game Misconduct",
    "Match"
  ].map(str => ({ text: str, value: str }))

  return (
    <Modal trigger={trigger} onClose={handleClose} open={open}>
      <Modal.Header>{penalty ? 'Edit Penalty' : 'New Penalty'}</Modal.Header>
      <Modal.Content>
      <Form {...form.form()}>
          <Form.Field required>
            <label>Time</label>
            <Form.Group>
              <Form.Field 
                control={Dropdown} 
                {...form.input('period')}                 
                required 
                search 
                selection 
                options={"1|2|3|OT".split("|").map(n => ({ text: n, value: n }))} 
                label={false}
                placeholder="Period"
                style={{ minWidth: '40%' }}
              />            
              <Form.Input 
                {...form.input('minute')} 
                label={false}
                placeholder="Min." 
                width="2" 
              />
              <Form.Input 
                {...form.input('second')} 
                label={false}
                placeholder="Sec." 
                width="2" 
              />
            </Form.Group>
          </Form.Field>
          <Form.Field 
            control={Dropdown}
            {...form.input('teamId', { errorKey: 'team' })} 
            label="Team" 
            required 
            search 
            selection 
            options={teams.map(t => ({ text: t.name, value: t.id }))} 
          />
          <Form.Field 
            control={Dropdown} 
            {...form.input('committedById', { errorKey: 'committedBy' })}             
            label="Player" 
            required 
            search 
            selection 
            options={skaterOptions} 
          />
          <Form.Field 
            control={Dropdown} 
            {...form.input('infraction')}  
            required
            search 
            selection 
            allowAdditions
            options={infractionOptions} 
            onAddItem={handleAddInfraction}
          />
          <Form.Field 
            control={Dropdown} 
            {...form.input('severity')} 
            required
            search 
            selection 
            options={severityOptions} 
          />
          <Form.Input
            {...form.input('duration')} 
            required
            width="3"
          />
          <Form.Field>
            <label>Start Time</label>
            <Form.Group>
              <Form.Field 
                control={Dropdown} 
                {...form.input('startPeriod')}                 
                required 
                search 
                selection 
                options={"1|2|3|OT".split("|").map(n => ({ text: n, value: n }))} 
                label={false}
                placeholder="Period"
                style={{ minWidth: '40%' }}
              />            
              <Form.Input 
                {...form.input('startMinute')} 
                label={false}
                placeholder="Min." 
                width="2" 
              />
              <Form.Input 
                {...form.input('startSecond')} 
                label={false}
                placeholder="Sec." 
                width="2" 
              />
            </Form.Group>
          </Form.Field>    
          <Form.Field>
            <label>End Time</label>
            <Form.Group>
              <Form.Field 
                control={Dropdown} 
                {...form.input('endPeriod')}                 
                required 
                search 
                selection 
                options={"1|2|3|OT".split("|").map(n => ({ text: n, value: n }))} 
                label={false}
                placeholder="Period"
                style={{ minWidth: '40%' }}
              />            
              <Form.Input 
                {...form.input('endMinute')} 
                label={false}
                placeholder="Min." 
                width="2" 
              />
              <Form.Input 
                {...form.input('endSecond')} 
                label={false}
                placeholder="Sec." 
                width="2" 
              />
            </Form.Group>
          </Form.Field>              
        </Form>
      </Modal.Content>
      <Modal.Actions>
        <Button primary content="Save Penalty" onClick={form.submit} />
      </Modal.Actions>
    </Modal>
  )
}

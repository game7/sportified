import React, { FC, useState } from 'react';
import { Button, Modal, Form, Dropdown, Select } from 'semantic-ui-react';
import { Settings, Action, Team, Skater, Goal } from '../../common/types';
import { useForm } from '../../common/hooks';
import { sortBy } from 'lodash';

interface AddGoalProps {
  settings: Settings;
  teams: Team[];
  skaters: Skater[];
  dispatch: React.Dispatch<Action>
}

export const AddGoal: FC<AddGoalProps> = ({ settings, teams, skaters, dispatch }) => {
  const DEFAULTS: Partial<Goal> = { 
    minute: "",
    second: "",
    strength: "5-5"
  }

  function reset() {
    form.setModel(DEFAULTS);
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

  async function handleSubmit(model: Goal, setErrors) {
    const url = `/admin/hockey_statsheets/${settings.id}/goals`
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const body = JSON.stringify({ hockey_goal: model })
    const response = await fetch(url, { method: 'POST', headers: headers, body: body })
    if(response.status == 422) {
      setErrors((await response.json()).messages)
    } else {
      const game = await response.json();
      dispatch({ type: 'goal/added', payload: game });
      handleClose();
    }
  }

  const [open, setOpen] = useState(false)
  const form = useForm<Goal>(DEFAULTS, handleSubmit)
  const trigger = (<Button primary content="Add Goal" onClick={handleOpen} />);

  const skaterOptions = sortBy(skaters.filter(p => p.teamId == form.model.teamId).map(p => ({ text: `${p.jerseyNumber} - ${p.lastName}, ${p.firstName}`, value: p.id })), "text")
  const strengthOptions = [
    "5-5",
    "5-4",
    "5-3",
    "4-5",
    "4-4",
    "4-3",
    "3-5",
    "3-4",
    "3-3",
  ].map(val => ({ text: val, value: val }))  

  return (
    <Modal trigger={trigger} onClose={handleClose} open={open}>
      <Modal.Header>Add Goal</Modal.Header>
      <Modal.Content>
        <Form {...form.form()}>
          <Form.Field required>
            <label>Time</label>
            <Form.Group>
              {/* <Form.Field 
                control={Dropdown} 
                {...form.input('period')}                 
                required 
                search 
                selection 
                options={"1|2|3|OT".split("|").map(n => ({ text: n, value: n }))} 
                label={false}
                placeholder="Period"
                style={{ minWidth: '40%' }}
              />    */}
              <Form.Input 
                {...form.input('period')} 
                label={false}
                placeholder="Per."
                width="2" 
                autoFocus
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
            control="select"
            {...form.input('teamId', { errorKey: 'team' })} 
            label="Team" 
            required 
            width="6"
          >
            <React.Fragment>
              <option></option>
              {teams.map(t => (<option key={t.id} value={t.id}>{t.name}</option>))} 
            </React.Fragment>
          </Form.Field>
          <Form.Field 
            control="select"
            {...form.input('scoredById', { errorKey: 'scoredBy' })}             
            label="Scored By" 
            required 
            width="6"
          >
            <React.Fragment>
              <option></option>
              {skaterOptions.map(o => (<option key={o.value} value={o.value}>{o.text}</option>))}
            </React.Fragment>
          </Form.Field>
          <Form.Field 
            control="select"
            {...form.input('assistedById', { errorKey: 'assistedBy' })}  
            label="Assisted By"  
            width="6"
          >
            <React.Fragment>
              <option></option>
              {skaterOptions.map(o => (<option key={o.value} value={o.value}>{o.text}</option>))}
            </React.Fragment>
          </Form.Field>
          <Form.Field 
            control="select" 
            {...form.input('alsoAssistedById', { errorKey: 'alsoAssistedBy' })} 
            label="Also Assisted By" 
            width="6"
          >
            <React.Fragment>
              <option></option>
              {skaterOptions.map(o => (<option key={o.value} value={o.value}>{o.text}</option>))}
            </React.Fragment>
          </Form.Field>
          <Form.Field 
            control="select" 
            {...form.input('strength')} 
            required 
            width="2"
          >
            <React.Fragment>
              <option></option>
              {strengthOptions.map(o => (<option key={o.value} value={o.value}>{o.text}</option>))}
            </React.Fragment>
          </Form.Field>
        </Form>
      </Modal.Content>
      <Modal.Actions>
        <Button primary content="Save Goal" onClick={form.submit} />
      </Modal.Actions>
    </Modal>
  )
}

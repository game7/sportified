import React, { FC, useState } from 'react';
import { Button, Modal, Form, Dropdown } from 'semantic-ui-react';
import { Settings, Action, Team, Skater, Goal } from '../../common/types';
import { useForm } from '../../common/hooks';

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

  const skaterOptions = skaters.filter(p => p.teamId === form.model.teamId).map(p => ({ text: `${p.jerseyNumber} - ${p.lastName}, ${p.firstName}`, value: p.id }))
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
    <Modal trigger={trigger} onClose={handleClose} open={open} size="tiny">
      <Modal.Header>Add Goal</Modal.Header>
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
            {...form.input('scoredById', { errorKey: 'scoredBy' })}             
            label="Scored By" 
            required 
            search 
            selection 
            options={skaterOptions} 
          />
          <Form.Field 
            control={Dropdown} 
            {...form.input('assistedById', { errorKey: 'assistedBy' })}  
            label="Assisted By" 
            search 
            selection 
            options={skaterOptions} 
          />
          <Form.Field 
            control={Dropdown} 
            {...form.input('alsoAssistedById', { errorKey: 'alsoAssistedBy' })} 
            label="Also Assisted By" 
            search 
            selection 
            options={skaterOptions} 
          />
          <Form.Field 
            control={Dropdown} 
            {...form.input('strength')} 
            required 
            search 
            selection 
            options={strengthOptions} 
          />
      
        </Form>
      </Modal.Content>
      <Modal.Actions>
        <Button primary content="Save Goal" onClick={form.submit} />
      </Modal.Actions>
    </Modal>
  )
}

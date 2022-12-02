import React, { FC, useState } from 'react';
import { Settings, Skater, Action, Team } from '../../common/types';
import { Button, Modal, Form } from 'semantic-ui-react'
import { useForm } from '../../common/hooks';

interface AddPlayerProps {
  settings: Settings;
  teams: Team[];
  dispatch: React.Dispatch<Action>;
}

export const AddPlayer: FC<AddPlayerProps> = ({ settings, teams, dispatch }) => {

  const model: Partial<Skater> = { 
    firstName: "",
    lastName: "",
    jerseyNumber: "",
    gamesPlayed: 1
  }

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

  async function handleSubmit(model: Skater, setErrors) {
    const url = `/admin/hockey_statsheets/${settings.id}/players`
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    
    const body = JSON.stringify({ hockey_skater_result: {
      ...model,
      gamesPlayed: model.gamesPlayed ? 1 : 0
    }})
    const response = await fetch(url, { method: 'POST', headers: headers, body: body })
    if(response.status == 422) {
      setErrors((await response.json()).messages)
    } else {
      const game = await response.json();
      dispatch({ type: 'skater/added', payload: game });
      handleClose();
    }
  }

  const [open, setOpen] = useState(false)
  const form = useForm<Skater>(model, handleSubmit)
  const trigger = (<Button primary content="Add Player" onClick={handleOpen} />);

  const teamOptions = teams.map(t => ({ text: t.name, value: t.id}))

  return (
    <Modal trigger={trigger} onClose={handleClose} open={open} size="tiny">
      <Modal.Header>Add Player</Modal.Header>
      <Modal.Content>
        <Form {...form.form()}>
          <Form.Dropdown {...form.input('teamId', { errorKey: 'team' })} label="Team" options={teamOptions} search selection required />
          <Form.Input {...form.input('firstName')} required />
          <Form.Input {...form.input('lastName')} required />
          <Form.Input {...form.input('jerseyNumber')} width="3" />
          <Form.Checkbox {...form.checkbox('gamesPlayed')} label="Played?" />
        </Form>
      </Modal.Content>
      <Modal.Actions>
        <Button primary content="Save Player" onClick={form.submit} />
      </Modal.Actions>
    </Modal>
  )
}

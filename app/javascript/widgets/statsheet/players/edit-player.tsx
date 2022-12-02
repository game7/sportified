import React, { FC, useState } from 'react';
import { Settings, Skater, Action } from '../../common/types';
import { Button, Modal, Form } from 'semantic-ui-react'
import { useForm } from '../../common/hooks';
import { pick } from 'lodash'


interface EditPlayerProps {
  settings: Settings;
  skater: Skater;
  dispatch: React.Dispatch<Action>
}

export const EditPlayer: FC<EditPlayerProps> = ({ settings, skater, dispatch }) => {

  const model = pick(skater, "id", "firstName", "lastName", "jerseyNumber", "gamesPlayed")

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
    const url = `/admin/hockey_statsheets/${settings.id}/players/${model.id}`
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    

    const body = JSON.stringify({ hockey_skater_result: {
      ...model,
      gamesPlayed: model.gamesPlayed ? 1 : 0
    }})
    const response = await fetch(url, { method: 'PATCH', headers: headers, body: body })
    if(response.status == 422) {
      setErrors((await response.json()).messages)
    } else {
      const game = await response.json();
      dispatch({ type: 'skater/updated', payload: game });
      handleClose();
    }
  }

  const [open, setOpen] = useState(false)
  const form = useForm<Skater>(model, handleSubmit)
  const trigger = (<Button primary size="mini" content="Edit" onClick={handleOpen} />);

  return (
    <Modal trigger={trigger} onClose={handleClose} open={open} size="tiny">
      <Modal.Header>Edit Player</Modal.Header>
      <Modal.Content>
        <Form {...form.form()}>
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

import React, { FC, useState, Dispatch } from 'react'
import { Button, Form, Modal, Table } from 'semantic-ui-react';
import { Statsheet, Action, Settings } from '../../common/types';
import { useForm } from '../../common/hooks';
import { pick } from 'lodash';

interface Props {
  statsheet: Statsheet
  dispatch: Dispatch<Action>
}

export const EditPeriods: FC<Props> = ({ statsheet, dispatch }) => {
  const { settings } = statsheet;

  function handleClose() {
    setOpen(false);
  }

  function handleOpen() {
    form.setModel(model)
    setOpen(true);
  }

  async function handleSubmit(model, setErrors) {
    const url = `/admin/hockey_statsheets/${settings.id}`
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }    

    const body = JSON.stringify({ hockey_statsheet: {
      min_1: model.min1,
      min_2: model.min2,
      min_3: model.min3,
      min_ot: model.minOt
    }})
    const response = await fetch(url, { method: 'PATCH', headers: headers, body: body })
    if(response.status == 422) {
      setErrors((await response.json()).messages)
    } else {
      const updated = await response.json();
      dispatch({ type: 'periods/updated', payload: updated });
      handleClose();
    }
  }

  const [open, setOpen] = useState(false)
  const model = pick(settings, "min1", "min2", "min3", "minOt")
  const form = useForm<Settings>(model, handleSubmit)
  const trigger = <Button content="Edit Periods" onClick={handleOpen} primary />


  return (
    <Modal trigger={trigger} onClose={handleClose} open={open} size="small">
      <Modal.Header>Edit Periods</Modal.Header>
      <Modal.Content>
        <Form {...form.form()}>

          <Table celled>
            <Table.Header>
              <Table.Row>
                <Table.HeaderCell content=""/>
                <Table.HeaderCell content="1" textAlign="center" />
                <Table.HeaderCell content="2" textAlign="center" />
                <Table.HeaderCell content="3" textAlign="center" />
                <Table.HeaderCell content="OT" textAlign="center" />
              </Table.Row>
            </Table.Header>
            <Table.Body>
              <Table.Row>
                <Table.Cell content="Duration" />
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("min1")} label={false} width="16" style={{ textAlign: 'center' }}  />
                </Table.Cell>
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("min2")} label={false} width="16" style={{ textAlign: 'center' }}  />
                </Table.Cell>
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("min3")} label={false} width="16" style={{ textAlign: 'center' }}  />
                </Table.Cell>
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("minOt")} label={false} width="16" style={{ textAlign: 'center' }}  />
                </Table.Cell>
              </Table.Row>
            </Table.Body>
          </Table>

        </Form>
      </Modal.Content>
      <Modal.Actions>
        <Button primary content="Save Periods" onClick={form.submit} />
      </Modal.Actions>
    </Modal>
  )

}

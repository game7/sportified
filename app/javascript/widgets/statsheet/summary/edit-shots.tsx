import React, { FC, useState, Dispatch } from 'react'
import { Button, Form, Modal, Table } from 'semantic-ui-react';
import { Statsheet, Action, Settings, Team } from '../../common/types';
import { useForm } from '../../common/hooks';
import { pick, toInteger } from 'lodash';

interface Props {
  statsheet: Statsheet
  homeTeam: Team
  awayTeam: Team
  dispatch: Dispatch<Action>
}

export const EditShots: FC<Props> = ({ statsheet, homeTeam, awayTeam, dispatch }) => {
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
      away_shots_1: model.awayShots1,
      away_shots_2: model.awayShots2,
      away_shots_3: model.awayShots3,
      away_shots_ot: model.awayShotsOt,
      home_shots_1: model.homeShots1,
      home_shots_2: model.homeShots2,
      home_shots_3: model.homeShots3,
      home_shots_ot: model.homeShotsOt
    }})
    const response = await fetch(url, { method: 'PATCH', headers: headers, body: body })
    if(response.status == 422) {
      setErrors((await response.json()).messages)
    } else {
      const updated = await response.json();
      dispatch({ type: 'shots/updated', payload: updated });
      handleClose();
    }
  }
  
  const [open, setOpen] = useState(false)
  const model = pick(settings, "awayShots1", "awayShots2", "awayShots3", "awayShotsOt", "homeShots1", "homeShots2", "homeShots3", "homeShotsOt")
  const form = useForm<Settings>(model, handleSubmit)
  const trigger = <Button content="Edit Shots" onClick={handleOpen} primary />

  const int = toInteger;
  const awayTotal = int(form.model.awayShots1) + int(form.model.awayShots2) + int(form.model.awayShots3) + int(form.model.awayShotsOt)
  const homeTotal = int(form.model.homeShots1) + int(form.model.homeShots2) + int(form.model.homeShots3) + int(form.model.homeShotsOt)

  return (
    <Modal trigger={trigger} onClose={handleClose} open={open}>
      <Modal.Header>Edit Shots</Modal.Header>
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
                <Table.HeaderCell content="Total" textAlign="center" />
              </Table.Row>
            </Table.Header>
            <Table.Body>
              <Table.Row>
                <Table.Cell content={awayTeam.name} />
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("awayShots1")} label={false} width="16" style={{ textAlign: 'center' }}  />
                </Table.Cell>
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("awayShots2")} label={false} width="16" style={{ textAlign: 'center' }}  />
                </Table.Cell>
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("awayShots3")} label={false} width="16" style={{ textAlign: 'center' }}  />
                </Table.Cell>
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("awayShotsOt")} label={false} width="16" style={{ textAlign: 'center' }}  />
                </Table.Cell>
                <Table.Cell width="2" textAlign="center" content={awayTotal} />
              </Table.Row>
              <Table.Row>
                <Table.Cell content={homeTeam.name} />
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("homeShots1")} label={false} width="16" style={{ textAlign: 'center' }} />
                </Table.Cell>
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("homeShots2")} label={false} width="16" style={{ textAlign: 'center' }}  />
                </Table.Cell>
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("homeShots3")} label={false} width="16" style={{ textAlign: 'center' }}  />
                </Table.Cell>
                <Table.Cell width="2" textAlign="center">
                  <Form.Input {...form.input("homeShotsOt")} label={false} width="16" style={{ textAlign: 'center' }}  />
                </Table.Cell>
                <Table.Cell width="2" textAlign="center" content={homeTotal} />
              </Table.Row>
            </Table.Body>
          </Table>

        </Form>
      </Modal.Content>
      <Modal.Actions>
        <Button primary content="Save Shots" onClick={form.submit} />
      </Modal.Actions>
    </Modal>
  )

}

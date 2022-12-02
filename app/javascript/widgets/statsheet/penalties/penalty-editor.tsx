import React, { FC, useState } from "react";
import { Settings, Skater, Team, Penalty, Action } from "../../common/types";
import { Button, Modal, Form, Dropdown } from "semantic-ui-react";
import { useForm } from "../../common/hooks";
import { omit, sortBy } from "lodash";

type Mode = "new" | "edit";

interface PenaltyEditorProps {
    settings: Settings;
    teams: Team[];
    skaters: Skater[];
    penalty?: Penalty;
    dispatch: React.Dispatch<Action>;
}

export const PenaltyEditor: FC<PenaltyEditorProps> = ({
    settings,
    penalty,
    skaters,
    teams,
    dispatch,
}) => {
    const model = penalty
        ? omit(penalty, "createdAt", "updatedAt")
        : {
              infraction: "",
              severity: "",
          };

    function reset() {
        form.setModel(model);
        form.setErrors({});
    }

    function handleOpen() {
        reset();
        setOpen(true);
    }

    function handleClose() {
        reset();
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
        "Bench minor",
        "Head contact",
    ]);

    async function handleSubmit(model: Penalty, setErrors) {
        const url = penalty
            ? `/admin/hockey_statsheets/${settings.id}/penalties/${model.id}`
            : `/admin/hockey_statsheets/${settings.id}/penalties`;
        const method = penalty ? "PATCH" : "POST";
        const headers = {
            Accept: "application/json",
            "Content-Type": "application/json",
        };
        const body = JSON.stringify({ hockey_penalty: { ...model } });
        const response = await fetch(url, { method, headers, body });
        if (response.status == 422) {
            setErrors((await response.json()).messages);
        } else {
            const type = penalty ? "penalty/updated" : "penalty/created";
            const payload = await response.json();
            dispatch({ type, payload });
            handleClose();
        }
    }

    // function handleAddInfraction(_event, { value }) {
    //   setInfractions(infractions => [...infractions, value])
    // }

    const [open, setOpen] = useState(false);
    const form = useForm<Penalty>(model, handleSubmit);
    const trigger = (
        <Button
            primary
            content={penalty ? "Edit" : "Add Penalty"}
            size={penalty ? "mini" : "medium"}
            onClick={handleOpen}
        />
    );

    const skaterOptions = sortBy(
        skaters
            .filter((p) => p.teamId == form.model.teamId)
            .map((p) => ({
                text: `${p.jerseyNumber} - ${p.lastName}, ${p.firstName}`,
                value: p.id,
            })),
        "text"
    );
    const infractionOptions = sortBy(
        infractions.map((str) => ({ text: str, value: str })),
        (opt) => opt.text
    );
    const severityOptions = [
        "Minor",
        "Major",
        "Misconduct",
        "Game Misconduct",
        "Match",
    ].map((str) => ({ text: str, value: str }));

    return (
        <Modal trigger={trigger} onClose={handleClose} open={open}>
            <Modal.Header>
                {penalty ? "Edit Penalty" : "New Penalty"}
            </Modal.Header>
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
                placeholder`="Period"
                style={{ minWidth: '40%' }}
              />             */}
                            <Form.Input
                                {...form.input("period")}
                                label={false}
                                placeholder="Per."
                                width="2"
                                autoFocus
                            />
                            <Form.Input
                                {...form.input("minute")}
                                label={false}
                                placeholder="Min."
                                width="2"
                            />
                            <Form.Input
                                {...form.input("second")}
                                label={false}
                                placeholder="Sec."
                                width="2"
                            />
                        </Form.Group>
                    </Form.Field>
                    <Form.Field
                        control="select"
                        {...form.input("teamId", { errorKey: "team" })}
                        label="Team"
                        required
                        options={teams.map((t) => ({
                            text: t.name,
                            value: t.id,
                        }))}
                        width="6"
                    >
                        <React.Fragment>
                            <option></option>
                            {teams.map((t) => (
                                <option key={t.id} value={t.id}>
                                    {t.name}
                                </option>
                            ))}
                        </React.Fragment>
                    </Form.Field>
                    <Form.Field
                        control="select"
                        {...form.input("committedById", {
                            errorKey: "committedBy",
                        })}
                        label="Player"
                        required
                        width="6"
                    >
                        <React.Fragment>
                            <option></option>
                            {skaterOptions.map((o) => (
                                <option key={o.value} value={o.value}>
                                    {o.text}
                                </option>
                            ))}
                        </React.Fragment>
                    </Form.Field>
                    {/* <Form.Field 
            control={Dropdown} 
            {...form.input('infraction')}  
            required
            search 
            selection 
            allowAdditions
            options={infractionOptions} 
            onAddItem={handleAddInfraction}
          /> */}
                    <Form.Field
                        control="select"
                        {...form.input("infraction")}
                        required
                        width="6"
                    >
                        <React.Fragment>
                            <option></option>
                            {infractionOptions.map((o) => (
                                <option key={o.value} value={o.value}>
                                    {o.text}
                                </option>
                            ))}
                        </React.Fragment>
                    </Form.Field>
                    {/* <Form.Input 
            {...form.input('infraction')}  
            required
            width="3"
          />           */}
                    <Form.Field
                        control="select"
                        {...form.input("severity")}
                        required
                        width="3"
                    >
                        <React.Fragment>
                            <option></option>
                            {severityOptions.map((o) => (
                                <option key={o.value} value={o.value}>
                                    {o.text}
                                </option>
                            ))}
                        </React.Fragment>
                    </Form.Field>
                    <Form.Input
                        {...form.input("duration")}
                        required
                        width="3"
                    />
                    <Form.Field>
                        <label>Start Time</label>
                        <Form.Group>
                            {/* <Form.Field 
                control={Dropdown} 
                {...form.input('startPeriod')}                 
                required 
                search 
                selection 
                options={"1|2|3|OT".split("|").map(n => ({ text: n, value: n }))} 
                label={false}
                placeholder="Period"
                selectOnBlur={false}
                style={{ minWidth: '40%' }}
              />   */}
                            <Form.Input
                                {...form.input("startPeriod")}
                                label={false}
                                placeholder="Per."
                                width="2"
                            />
                            <Form.Input
                                {...form.input("startMinute")}
                                label={false}
                                placeholder="Min."
                                width="2"
                            />
                            <Form.Input
                                {...form.input("startSecond")}
                                label={false}
                                placeholder="Sec."
                                width="2"
                            />
                        </Form.Group>
                    </Form.Field>
                    <Form.Field>
                        <label>End Time</label>
                        <Form.Group>
                            {/* <Form.Field 
                control={Dropdown} 
                {...form.input('endPeriod')}                 
                required 
                search 
                selection 
                options={"1|2|3|OT".split("|").map(n => ({ text: n, value: n }))} 
                label={false}
                placeholder="Period"
                selectOnBlur={false}
                style={{ minWidth: '40%' }}
              />             */}
                            <Form.Input
                                {...form.input("endPeriod")}
                                label={false}
                                placeholder="Per."
                                width="2"
                            />
                            <Form.Input
                                {...form.input("endMinute")}
                                label={false}
                                placeholder="Min."
                                width="2"
                            />
                            <Form.Input
                                {...form.input("endSecond")}
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
    );
};

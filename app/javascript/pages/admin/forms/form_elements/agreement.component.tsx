import { Checkbox, Input } from "@mantine/core";
import { startCase } from "lodash";
import { CSSProperties, Fragment } from "react";

interface Props {
  element: FormElements.Agreement;
}

const AGREEMENT_STYLE: CSSProperties = {
  // zwidth: '100%',
  whiteSpace: "pre-wrap",
  wordBreak: "break-word",
  border: "1px solid rgba(34, 36, 38, 0.15)",
  padding: 5,
  height: 200,
  overflowX: "hidden",
  overflowY: "scroll",
  backgroundColor: "#f9f9f9",
  margin: 0,
  marginBottom: 10,
  borderRadius: "0.28571429rem",
};

export function Agreement({ element }: Props) {
  return (
    <Fragment>
      <Input.Wrapper
        label={startCase(element.name || "")}
        description={element.hint}
      >
        <pre style={AGREEMENT_STYLE}>{element.terms}</pre>
        <Checkbox label="Agree?" />
      </Input.Wrapper>
    </Fragment>
  );
}

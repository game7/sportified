import { Agreement } from "./agreement.component";
import { Choice } from "./choice.component";
import { Contact } from "./contact.component";
import { Note } from "./note.component";
import { Text } from "./text.component";

interface Props {
  element: App.FormElement;
}

export function FormElement({ element }: Props) {
  const { type } = element;

  switch (type) {
    case "FormElements::Text":
      return <Text element={element} />;
    case "FormElements::Choice":
      return <Choice element={element} />;
    case "FormElements::Agreement":
      return <Agreement element={element} />;
    case "FormElements::Note":
      return <Note element={element} />;
    case "FormElements::Contact":
      return <Contact element={element} />;
    default:
      return <div>{JSON.stringify(element, null, 2)}</div>;
  }
}

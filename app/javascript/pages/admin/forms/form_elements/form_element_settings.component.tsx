import { AgreementSettings } from "./agreement_settings.component";
import { ChoiceSettings } from "./choice_settings.component";
import { ContactSettings } from "./contact_settings.component";
import { NoteSettings } from "./note_settings.component";
import { TextSettings } from "./text_settings.component";

interface Props {
  element: App.FormElement;
  onSuccess?: () => void;
}

export function FormElementSettings({ element, onSuccess }: Props) {
  const { type } = element;

  switch (type) {
    case "FormElements::Text":
      return <TextSettings element={element as any} onSuccess={onSuccess} />;
    case "FormElements::Choice":
      return <ChoiceSettings element={element as any} onSuccess={onSuccess} />;
    case "FormElements::Agreement":
      return (
        <AgreementSettings element={element as any} onSuccess={onSuccess} />
      );
    case "FormElements::Note":
      return <NoteSettings element={element as any} onSuccess={onSuccess} />;
    case "FormElements::Contact":
      return <ContactSettings element={element as any} onSuccess={onSuccess} />;
    default:
      return <div>{JSON.stringify(element, null, 2)}</div>;
  }
}

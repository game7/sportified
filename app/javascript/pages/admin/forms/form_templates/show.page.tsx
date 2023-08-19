import { ActionIcon, Box, Group, Modal, Stack } from "@mantine/core";
import { IconArrowDown, IconArrowUp, IconSettings } from "@tabler/icons-react";
import { AdminLayout } from "~/components/layout/admin-layout";
import { actions } from "~/routes";
import { usePage } from "~/utils/use-page";
import { useSearchParams } from "~/utils/use-search-params";
import { FormElement } from "../form_elements/form_element.component";
import { FormElementSettings } from "../form_elements/form_element_settings.component";

interface Props {
  template: App.FormTemplate;
  packet: App.FormPacket;
  elements: App.FormElement[];
}

export default function AdminFormsFormTemplatesShowPage() {
  const page = usePage<Props>();
  const { template, packet, elements } = page.props;

  const [searchParams, setSearchParams] = useSearchParams();

  function findElement() {
    if (!searchParams.has("element")) {
      return null;
    }

    const elementId = parseInt(searchParams.get("element") || "");
    return elements.find((element) => element.id === elementId);
  }

  const element = findElement();
  const opened = !!element;

  function handleSettingsClick(element: App.FormElement) {
    searchParams.set("element", element.id.toString());
    page.props.errors = {};

    setSearchParams(searchParams, {
      preserveScroll: true,
      replace: true,
    });
  }

  function handleClose() {
    searchParams.delete("element");
    setSearchParams(searchParams, {
      preserveScroll: true,
      replace: true,
    });
  }

  function handleMoveDownClick(index: number) {
    const ids = elements.map((element) => element.id);
    ids.splice(index + 1, 0, ids.splice(index, 1)[0]);
    actions["next/admin/forms/form_templates/form_elements"]["order"].post(
      { form_template_id: template.id },
      { ids },
      { preserveScroll: true, replace: true }
    );
  }

  function handleMoveUpClick(index: number) {
    const ids = elements.map((element) => element.id);
    ids.splice(index - 1, 0, ids.splice(index, 1)[0]);
    actions["next/admin/forms/form_templates/form_elements"]["order"].post(
      { form_template_id: template.id },
      { ids },
      { preserveScroll: true, replace: true }
    );
  }

  return (
    <AdminLayout
      title={packet.name || ""}
      breadcrumbs={[
        {
          label: "Forms",
          href: actions["next/admin/forms"]["index"].path({}),
        },
        {
          label: packet.name || "",
          href: actions["next/admin/forms/form_packets"]["show"].path({
            id: packet.id,
          }),
        },

        {
          label: template.name || "",
          href: actions["next/admin/forms/form_templates"]["show"].path({
            id: template.id,
          }),
        },
      ]}
      extra={[]}
    >
      <Stack>
        {elements.map((element, index) => (
          <Box
            sx={(theme) => ({
              padding: 10,
              borderColor: theme.colors.gray[5],
              borderWidth: 1,
              borderStyle: "dashed",
              position: "relative",
            })}
          >
            <Box
              sx={(theme) => ({
                position: "absolute",
                right: 10,
                top: 10,
                zIndex: 10,
                padding: 5,
                backgroundColor: theme.colors.gray[0],
                borderRadius: theme.radius.sm,
              })}
            >
              <Group spacing="xs" sx={{ gap: "0.250rem" }}>
                <ActionIcon
                  variant="default"
                  onClick={() => {
                    handleSettingsClick(element);
                  }}
                  title="Element Settings"
                >
                  <IconSettings size="1rem" />
                </ActionIcon>
                <ActionIcon
                  variant="default"
                  disabled={index == 0}
                  onClick={() => handleMoveUpClick(index)}
                  title="Move Up"
                >
                  <IconArrowUp size="1rem" />
                </ActionIcon>
                <ActionIcon
                  variant="default"
                  disabled={index == elements.length - 1}
                  onClick={() => handleMoveDownClick(index)}
                  title="Move Down"
                >
                  <IconArrowDown size="1rem" />
                </ActionIcon>
              </Group>
            </Box>

            <FormElement key={element.id} element={element} />
          </Box>
        ))}
      </Stack>
      <Modal
        opened={opened}
        onClose={handleClose}
        title="Form Element Settings"
      >
        {element && (
          <FormElementSettings element={element} onSuccess={handleClose} />
        )}
      </Modal>
    </AdminLayout>
  );
}

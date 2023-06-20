import { Box, Grid, Input, TextInput } from "@mantine/core";
import { startCase } from "lodash";

interface Props {
  element: FormElements.Contact;
}

export function Contact({ element }: Props) {
  return (
    <Input.Wrapper label={startCase(element.name!)}>
      <Box
        sx={(theme) => ({
          borderColor: theme.colors.gray[4],
          borderWidth: 1,
          borderStyle: "solid",
          borderRadius: theme.radius.sm,
          padding: theme.spacing.md,
        })}
      >
        <Grid>
          <Grid.Col span={6}>
            <TextInput label="First Name" withAsterisk={!!element.required} />
          </Grid.Col>
          <Grid.Col span={6}>
            <TextInput label="Last Name" withAsterisk={!!element.required} />
          </Grid.Col>
          <Grid.Col span={6}>
            <TextInput label="Email" withAsterisk={!!element.required} />
          </Grid.Col>
          <Grid.Col span={6}>
            <TextInput label="Phone" withAsterisk={!!element.required} />
          </Grid.Col>
        </Grid>
      </Box>
    </Input.Wrapper>
  );
}

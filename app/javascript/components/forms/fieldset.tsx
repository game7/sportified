import { Box, Stack, Title } from "@mantine/core";
import { PropsWithChildren } from "react";

type FieldsetProps = PropsWithChildren<{
  title?: string;
}>;

export function Fieldset({ title, children }: FieldsetProps) {
  return (
    <Box
      data-with-border={true}
      sx={(theme) => ({
        display: "block",
        borderRadius: theme.radius.md,
        borderColor: theme.colors.gray[3],
        borderWidth: 1,
        borderStyle: "solid",
        padding: theme.spacing.md,
      })}
    >
      <Stack>
        {title && <Title order={5}>{title}</Title>}
        {children}
      </Stack>
    </Box>
  );
}

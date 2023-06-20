import { Box } from "@mantine/core";
import { CSSProperties } from "react";

export function Statistic({
  label,
  value,
  boxStyle,
}: {
  label: string;
  value: string | number;
  boxStyle?: CSSProperties;
}) {
  return (
    <Box style={boxStyle}>
      <Box
        sx={{
          textAlign: "center",
          textTransform: "uppercase",
          fontWeight: 400,
          fontSize: "4em",
          lineHeight: "1em",
        }}
      >
        {value}
      </Box>
      <Box
        sx={{
          textAlign: "center",
          textTransform: "uppercase",
          fontWeight: 600,
        }}
      >
        {label}
      </Box>
    </Box>
  );
}

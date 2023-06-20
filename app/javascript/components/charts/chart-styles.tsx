import { Global, useMantineTheme } from "@mantine/core";

// Shorter cleaner version to say `check ? value : undefined` when looking at dozens of conditionals.
export function onlyIf<T>(check: boolean, value: T) {
  if (check) return value;
  return undefined;
}

// Just plop this somewhere on the page or app that renders tremor charts.
export function ChartStyles() {
  const theme = useMantineTheme();
  const dark = theme.colorScheme === "dark";
  const colors = theme.colors;

  return (
    <Global
      styles={{
        ".recharts-wrapper .recharts-surface text": {
          fill: onlyIf(dark, colors.gray[0]),
        },
        ".recharts-cartesian-axis-tick text": {
          fill: onlyIf(dark, colors.gray[4] + "!important"),
        },
        ".tr-text-gray-500": {
          color: onlyIf(dark, colors.gray[4]),
        },
        ".tr-text-gray-700": {
          color: onlyIf(dark, colors.gray[0]),
        },
        ".tr-bg-white": {
          backgroundColor: onlyIf(dark, colors.dark[7]),
          color: onlyIf(dark, "white"),
        },
        ".tr-ring-gray-200": {
          borderColor: onlyIf(dark, colors.dark[4]),
          "--tw-ring-color": onlyIf(dark, colors.dark[4]),
        },
        ".tremor-base :is(*, ::before, ::after)": {
          borderColor: onlyIf(dark, colors.dark[4]),
        },
        ".recharts-pie-sector path.recharts-sector": {
          stroke: onlyIf(dark, colors.dark[4]),
        },
        '.recharts-cartesian-grid line[stroke="#ccc"]': {
          stroke: onlyIf(dark, colors.gray[6]),
        },
      }}
    />
  );
}

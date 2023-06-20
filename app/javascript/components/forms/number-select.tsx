import { Select, SelectProps } from "@mantine/core";
import { FC } from "react";

interface NumberSelectProps
  extends Omit<SelectProps, "value" | "onChange" | "data"> {
  value: number;
  onChange: (value: number) => void;
  data: { value: number; label: string }[];
}

export const NumberSelect: FC<NumberSelectProps> = (props) => {
  const { value, onChange, data, ...otherProps } = props;
  return (
    <Select
      {...otherProps}
      data={data.map(({ label, value }) => ({
        value: value.toString(),
        label,
      }))}
      value={value.toString()}
      onChange={(it) => onChange(Number(it) || 0)}
    />
  );
};

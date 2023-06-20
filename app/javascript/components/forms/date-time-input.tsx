import { Group } from "@mantine/core";
import { DateInput, DateValue, TimeInput } from "@mantine/dates";
import dayjs, { Dayjs } from "dayjs";
import { ComponentProps, useEffect, useState } from "react";

interface DateTimeInputProps {
  value?: ConstructorParameters<typeof Dayjs>[0];
  onChange?: (value: Dayjs | undefined) => void;
  dateInputProps?: ComponentProps<typeof DateInput>;
  timeInputProps?: ComponentProps<typeof TimeInput>;
  error?: string;
}

export function DateTimeInput(props: DateTimeInputProps) {
  const { value } = props;
  const [dateTime, setDateTime] = useState<Dayjs | undefined>(
    value ? dayjs(value) : undefined
  );

  useEffect(() => {
    props.onChange && props.onChange(dateTime);
  }, [dateTime]);

  function handleDateChange(value: DateValue) {
    let updated = dayjs(value);
    if (dateTime) {
      updated = updated
        .set("hour", dateTime.hour())
        .set("minute", dateTime.minute());
    }
    setDateTime(updated);
  }
  function handleTimeChange(value: string) {
    const parts = value.split(":");
    const updated = (dateTime || dayjs())
      .set("hour", parseInt(parts[0]))
      .set("minute", parseInt(parts[1]));
    setDateTime(updated);
  }
  return (
    <Group sx={{ display: "flex", alignItems: "flex-start" }}>
      <DateInput
        miw={100}
        maw={140}
        value={dateTime ? dateTime.toDate() : undefined}
        {...props.dateInputProps}
        onChange={handleDateChange}
        error={props.error}
      />
      <TimeInput
        miw={100}
        maw={140}
        value={dateTime ? dateTime.format("HH:mm") : ""}
        {...props.timeInputProps}
        onChange={(event) => handleTimeChange(event.target.value)}
        error={props.error ? " " : undefined}
      />
    </Group>
  );
}

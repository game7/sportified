import { Table } from "@mantine/core";
import { ReactNode } from "react";

export function PropertyTable({ children }: { children: ReactNode }) {
  return (
    <Table withBorder withColumnBorders>
      <tbody>{children}</tbody>
    </Table>
  );
}

PropertyTable.Item = PropertyTableItem;

function PropertyTableItem({
  label,
  children,
}: {
  label?: ReactNode;
  children?: ReactNode;
}) {
  return (
    <tr>
      <td width="20%">{label}</td>
      <td width="80%">{children}</td>
    </tr>
  );
}

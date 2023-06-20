import { DataTable, DataTableSortStatus } from "mantine-datatable";
import { useSearchParams } from "./use-search-params";
import { ComponentProps } from "react";
import { sortBy } from "lodash";

export function useSorting<T>(records: Array<T>, defaultColumn: keyof T) {
  const [searchParams, setSearchParams] = useSearchParams();
  const setOptions: Parameters<typeof setSearchParams>[1] = {
    replace: true,
    preserveScroll: true,
    preserveState: true,
  };

  const KEYS = {
    column: "sort_by",
    direction: "sort_direction",
  };

  const column = searchParams.get(KEYS.column) || defaultColumn.toString();
  const direction: "asc" | "desc" =
    searchParams.get(KEYS.direction) == "desc" ? "desc" : "asc";

  const sortStatus: DataTableSortStatus = {
    columnAccessor: column,
    direction,
  };

  const onSortStatusChange: ComponentProps<
    typeof DataTable
  >["onSortStatusChange"] = (status) => {
    if (status.columnAccessor == defaultColumn) {
      searchParams.delete(KEYS.column);
    } else {
      searchParams.set(KEYS.column, status.columnAccessor);
    }
    if (status.direction == "asc") {
      searchParams.delete(KEYS.direction);
    } else {
      searchParams.set(KEYS.direction, "desc");
    }
    setSearchParams(searchParams, setOptions);
  };

  const sorted =
    direction == "asc"
      ? sortBy(records, column)
      : sortBy(records, column).reverse();

  return {
    sortStatus,
    onSortStatusChange,
    records: sorted,
  };
}

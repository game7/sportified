import { ComponentProps } from "react";
import { useSearchParams } from "./use-search-params";
import { DataTable } from "mantine-datatable";

export function usePagination<T>(records: Array<T>) {
  const [searchParams, setSearchParams] = useSearchParams();
  const setOptions: Parameters<typeof setSearchParams>[1] = {
    replace: true,
    preserveScroll: true,
    preserveState: true,
  };

  const KEYS = {
    page: "page",
    per_page: "per_page",
  };

  const totalRecords = records.length;

  const recordsPerPageOptions = [10, 20, 50, 100];
  const recordsPerPageDefault = 20;
  const recordsPerPage = searchParams.has(KEYS.per_page)
    ? parseInt(
        searchParams.get(KEYS.per_page) || recordsPerPageDefault.toString()
      )
    : recordsPerPageDefault;

  const page = searchParams.has(KEYS.page)
    ? parseInt(searchParams.get(KEYS.page) || "1")
    : 1;

  const onPageChange: ComponentProps<typeof DataTable>["onPageChange"] = (
    p: number
  ) => {
    if (p > 1) {
      searchParams.set(KEYS.page, p.toString());
    } else {
      searchParams.delete(KEYS.page);
    }
    setSearchParams(searchParams, setOptions);
  };

  const onRecordsPerPageChange: ComponentProps<
    typeof DataTable
  >["onRecordsPerPageChange"] = (p: number) => {
    if (p != recordsPerPageDefault) {
      searchParams.set(KEYS.per_page, p.toString());
    } else {
      searchParams.delete(KEYS.per_page);
    }
    setSearchParams(searchParams, setOptions);
  };

  const from = (page - 1) * recordsPerPage;
  const to = from + recordsPerPage;

  return {
    records: records.slice(from, to),
    totalRecords,
    recordsPerPageOptions,
    recordsPerPage,
    onRecordsPerPageChange,
    page,
    onPageChange,
  };
}

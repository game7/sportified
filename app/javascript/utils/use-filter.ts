import { useForm } from "@mantine/form";
import { useSearchParams } from "./use-search-params";

export function useFilter<T>(
  records: Array<T>,
  options: {
    key: string;
    filter: (record: T, value: string) => boolean;
  }
) {
  const form = useForm({ initialValues: { name: "" } });
  const [searchParams, setSearchParams] = useSearchParams();
  const setOptions: Parameters<typeof setSearchParams>[1] = {
    replace: true,
    preserveScroll: true,
    preserveState: true,
  };

  const value = searchParams.get(options.key);

  const filtered = value
    ? records.filter((record) => options.filter(record, value))
    : records;

  const apply = (value: string | number | null) => {
    if (value) {
      searchParams.set(options.key, value.toString());
    } else {
      searchParams.delete(options.key);
    }
    setSearchParams(searchParams, setOptions);
  };

  const clear = () => apply(null);

  // wrap form onSubmit function
  const onSubmit = form.onSubmit((data, event) => {
    apply(data.name);
    event.stopPropagation();
  });

  // wrap form onReset function
  const onReset = (e: React.FormEvent<HTMLFormElement>) => {
    form.onReset(e);
    clear();
  };

  const active = !!value;

  return {
    records: filtered,
    form,
    apply,
    clear,
    active,
    formProps: {
      onSubmit,
      onReset,
    },
  };
}

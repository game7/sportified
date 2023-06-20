import { Inertia } from "@inertiajs/inertia";

type InertiaGetOptions = Parameters<typeof Inertia.get>[2];

export function useSearchParams() {
  const searchParams = new URLSearchParams(window.location.search);

  function setSearchParams(
    params: URLSearchParams,
    options: InertiaGetOptions = {}
  ) {
    options.only = options.only || ["noop"];
    Inertia.get("?", searchParams as any, options);
  }

  return [searchParams, setSearchParams] as const;
}

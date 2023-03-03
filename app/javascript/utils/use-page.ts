import { Page, PageProps } from "@inertiajs/inertia";
import { usePage as usePageInertia } from "@inertiajs/inertia-react";

export function usePage<Props = PageProps>() {
  return usePageInertia<Page<Props & App.SharedProps>>();
}

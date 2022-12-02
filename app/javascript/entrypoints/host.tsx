import { createInertiaApp } from "@inertiajs/inertia-react";
import dayjs from "dayjs";
import RelativeTime from "dayjs/plugin/relativeTime";
import { createRoot } from "react-dom/client";
import { ReactNode } from "react";

// antd variable styles
import "antd/dist/antd.variable.min.css";

// import "../styles/application.css";

// setup dayjs
dayjs.extend(RelativeTime);

// scan and load all pages.  these files are lazy loaded
// in local development mode for optimal performance 👌
// https://vitejs.dev/guide/features.html#glob-import
const pages = import.meta.glob<ReactNode>("../pages/host/**/*.page.tsx");

createInertiaApp({
  resolve: async (name) => {
    const resolver = pages[`../pages/${name}.page.tsx`];
    if (!resolver) {
      console.error(`page '${name}' not found in: `);
      console.table(Object.keys(pages));
      throw new Error(
        `Unknown page ${name}. Is it located under /app/javascript/pages/host with a .page.tsx extension?`
      );
    }
    const page = await resolver();
    return page;
  },
  setup({ el, App, props }) {
    const root = createRoot(el);
    root.render(<App {...props} />);
  },
});

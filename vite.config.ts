import { defineConfig } from "vite";
import RubyPlugin from "vite-plugin-ruby";
import ViteReact from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [RubyPlugin(), ViteReact()],
});

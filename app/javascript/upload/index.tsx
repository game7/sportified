import { createRoot } from "react-dom/client";
import Router from "./router";
import "./index.css";

const container = document.getElementById("uploader");
const root = createRoot(container!); // createRoot(container!) if you use TypeScript
root.render(<Router />);

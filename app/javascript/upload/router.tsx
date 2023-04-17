import { BrowserRouter as Router, Link, Route, Routes } from "react-router-dom";

import App from "./app";
import Events from "./events";
import Games from "./games";
import Players from "./players";
import Practices from "./practices";

function Home() {
  return (
    <ul>
      {/* <li>
        <Link to="/events">Events</Link>
      </li> */}
      <li>
        <Link to="/games">Games</Link>
      </li>
      {/* <li>
        <Link to="/practices">Practices</Link>
      </li> */}
      <li>
        <Link to="/players">Players</Link>
      </li>
    </ul>
  );
}

export default () => (
  <Router basename="/admin/uploads">
    <div>
      <App>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/games/*" element={<Games />} />
          <Route path="/practices/*" element={<Practices />} />
          <Route path="/events/*" element={<Events />} />
          <Route path="/players/*" element={<Players />} />
        </Routes>
      </App>
    </div>
  </Router>
);

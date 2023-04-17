import { Route, Routes } from "react-router-dom";

import Columns from "./columns";
import Context from "./context";
import Data from "./data";
import File from "./file";
import Mapping from "./mapping";
import Review from "./review";

export default function Import() {
  return (
    <Routes>
      <Route index element={<Context />} />
      <Route path="file" element={<File />} />
      <Route path="data" element={<Data />} />
      <Route path="columns" element={<Columns />} />
      <Route path="mapping" element={<Mapping />} />
      <Route path="review" element={<Review />} />
    </Routes>
  );
}

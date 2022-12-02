import { BrowserRouter, Routes, Route } from "react-router-dom";

// HOC to wrap a page component within React Router
// so that react router hooks may be used
export function withRouter<T extends JSX.IntrinsicAttributes>(
  WrappedComponent: React.ComponentType<T>
) {
  return function RouterWrapperComponent(props: T) {
    return (
      <BrowserRouter>
        <Routes>
          <Route path="*" element={<WrappedComponent {...props} />} />
        </Routes>
      </BrowserRouter>
    );
  };
}

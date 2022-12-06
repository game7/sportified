import {
  NavigateFunction,
  Params,
  useLocation,
  useNavigate,
  useParams,
} from "react-router-dom";

export function withRouter(Component: any) {
  function ComponentWithRouterProp(props: any) {
    let location = useLocation();
    let navigate = useNavigate();
    let params = useParams();
    return <Component {...props} router={{ location, navigate, params }} />;
  }

  return ComponentWithRouterProp;
}

export type RouteComponentProps<T> = T & {
  router: {
    location: Location;
    navigate: NavigateFunction;
    params: Readonly<Params<string>>;
  };
};

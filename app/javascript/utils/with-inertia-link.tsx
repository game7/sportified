import { Inertia } from "@inertiajs/inertia";
import { ButtonProps } from "antd";

type InertiaLinkable = ButtonProps;

// experimental HOC to attach inertial link handler to antd component.  if this works
// well we can relocated (and extend) as a reusable utility function
export function withInertiaLink<T extends InertiaLinkable>(
  WrappedComponent: React.ComponentType<T>
) {
  return function InertiaLinkWrapperComponent(props: T) {
    return (
      <WrappedComponent
        {...props}
        onClick={(e) => {
          if (props.href) {
            e.preventDefault();
            Inertia.get(props.href);
          }
        }}
      />
    );
  };
}

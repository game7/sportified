import * as React from 'react';

interface RowProps {
  children?: JSX.Element[]
}

export const Row = (props: RowProps) => (
  <div className="row">
    {props.children}
  </div>
)

interface ColProps {
  children?: JSX.Element[],
  xs?: number;
  sm?: number;
  md?: number;
  lg?: number;
}

export const Col = (props: ColProps) => {
  let classes = [];
  "xs|sm|md|lg".split("|").forEach(brk => {
    if(props[brk]) {
      classes.push(`col-${brk}-${props[brk]}`);
    }
  });
  return (
    <div className={classes.join(" ")}>
      {props.children}
    </div>
  )
}

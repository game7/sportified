import * as React from 'react';

export const Spacer = () => (<span> </span>);

export const Row = (props: { children?: JSX.Element}) => (
  <div className="row">
    {props.children}
  </div>
)

interface ColProps {
  xs?: number;
  sm?: number;
  md?: number;
  children?: JSX.Element;
}

const BREAKS = ['xs','sm','md', 'lg'];

export const Col = (props: ColProps) => {
  const classes = BREAKS.map(b => props[b] ? `col-${b}-${props[b]}` : '')
  return (
   <div className={classes.join(' ')}>
    {props.children}
   </div>
  );
}

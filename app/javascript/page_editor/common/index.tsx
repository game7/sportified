import * as React from 'react';

export const Spacer = () => (<span> </span>);

export const Row: React.SFC<{}> = (props) => (
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

export const Col: React.SFC<ColProps> = (props) => {
  const classes = BREAKS.map(b => props[b] ? `col-${b}-${props[b]}` : '')
  return (
   <div className={classes.join(' ')}>
    {props.children}
   </div>
  );
}

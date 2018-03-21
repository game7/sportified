import * as React from 'react';

interface RowProps {

}

export const Row: React.SFC<RowProps> = (props) => (
  <div className="row">
    {props.children}
  </div>
)

interface ColProps {
  xs?: number;
  sm?: number;
  md?: number;
  lg?: number;
}

export const Col: React.SFC<ColProps> = (props) => {
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

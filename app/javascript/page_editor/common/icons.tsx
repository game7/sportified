import * as React from 'react';
import { Spacer } from './index';

export const Icon = (props: { name: string, label?: string }) => {
  if(!props.label)
    return (
      <i className={`fa fa-${props.name}`}></i>
    )
  else
    return (
      <span>
        <i className={`fa fa-${props.name}`}></i>
        <Spacer/>
        {props.label}
      </span>
    )
}

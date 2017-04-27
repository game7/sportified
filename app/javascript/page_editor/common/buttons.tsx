import * as React from 'react';
import { FormEvent, ReactNode } from 'react';
import { Icon } from './icons';

export const ButtonGroup = (props: { children?: JSX.Element[] }) => (
  <div className="btn-group" role="group">
    {props.children}
  </div>
)

interface ButtonProps {
  icon?: string;
  label?: string;
  active?: boolean;
  onClick?: (event: FormEvent<HTMLButtonElement>) => void;
  disabled?: boolean;
}

export const Button = (props: ButtonProps & { className: string }) => {
  const className = `btn ${props.className} ${props.active ? 'active' : ''}`
  const { onClick } = props

  if (props.icon)
    return (
      <button type="button" className={className} onClick={onClick} disabled={props.disabled}>
        <Icon name={props.icon} label={props.label}/>
      </button>
    )
  else
    return (
      <button type="button" className={className} onClick={onClick} disabled={props.disabled}>{props.label}</button>
    )
}

export const DefaultButton = (props: ButtonProps) => {
  return (<Button {...props} className="btn-default"/>);
}

export const PrimaryButton = (props: ButtonProps) => {
  return (<Button {...props} className="btn-primary"/>);
}

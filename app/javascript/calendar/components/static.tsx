import * as React from 'react';

interface Props {
  label: string
}

export const Static: React.SFC<Props> = ({ label, children }) => {
  return (
    <div className="form-group">
      <label className="control-label">{label}</label>
      <div className="form-control-static">{children}</div>
    </div>
  )
}


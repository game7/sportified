import * as React from 'react';

interface Props {
  title: string,
  onClose?: () => void
}

export class Modal extends React.Component<Props,{}> {

  render() {
    const { title, onClose = () => {}, children } = this.props;
    return (
      <React.Fragment>
        <div className="modal fade in show" role="dialog">
          <div className="modal-dialog" role="document">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close" onClick={onClose}>
                  <span aria-hidden="true">&times;</span>
                </button>
                <h4 className="modal-title">{title}</h4>
              </div>
              <div className="modal-body">
                {children}
                <div className="clearfix"/>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-default" onClick={onClose}>Close</button>
              </div>
            </div>
          </div>
        </div>
        <div className="modal-backdrop fade in"/>
      </React.Fragment>
    )
  }

}

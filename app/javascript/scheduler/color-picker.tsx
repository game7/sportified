import * as React from 'react';
import './color-picker.scss';


interface Props {

}

interface State {
  expanded: boolean,
  selection?: string
}

const rows = [
  [
    '#b60205',
    '#d93f0b',
    '#fbca04',
    '#0e8a16',
    '#006b75',
    '#1d76db',
    '#0052cc',
    '#5319e7'
  ],
  [
    '#e99695',
    '#f9d0c4',
    '#fef2c0',
    '#c2e0c6',
    '#bfdadc',
    '#c5def5',
    '#bfd4f2',
    '#d4c5f9'
  ]
]

export class ColorPicker extends React.Component<Props,State> {

  readonly state: State = {
    expanded: false
  }

  toggleExpanded = () => {
    const { expanded } = this.state;
    this.setState({ expanded: !expanded })
  }

  handleSelection = (color: string) => {
    this.setState({
      expanded: false,
      selection: color
    })
  }

  render() {
    const { expanded, selection = '' } = this.state;
    return (
      <div className={`dropdown ${expanded ? 'open' : ''}`}>
        <button
          className="btn btn-default"
          onClick={this.toggleExpanded}
          style={{ backgroundColor: selection }}
        >
          Color
        </button>
        <div className="dropdown-menu">
          {rows.map(colors => (
            <ColorChooser>
              {colors.map(color => (
                  <ColorChooserColor color={color} onClick={this.handleSelection} />
              ))}
            </ColorChooser>
          ))}
        </div>
      </div>
    );
  }
}

const ColorChooser: React.SFC<{}> = ({ children }) => (
  <ul className="color-chooser">
    {children}
  </ul>
)

const ColorChooserColor: React.SFC<{ color: string, onClick?: (color: string) => void }> = ({ color, onClick }) => {
  const handleClick = () => { if(onClick) onClick(color) }
  return (
    <li>
      <div
        className='color-chooser-color'
        style={{ background: color }}
        onClick={handleClick}
      />
    </li>
  )
}

export default ColorPicker;

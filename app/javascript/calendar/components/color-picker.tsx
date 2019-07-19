import * as React from 'react';
import './color-picker.scss';


interface Props {
  expanded: boolean,
  onSelection?: (color: string) => void
}

interface State {

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


  handleSelection = (color: string) => {
    const { onSelection } = this.props;
    if(onSelection) onSelection(color);
  }

  render() {
    const { expanded } = this.props;
    return (
      <div className={`dropdown ${expanded ? 'open' : ''}`}>
        <div className="dropdown-menu">
          {rows.map((colors, i) => (
            <ColorChooser key={i}>
              {colors.map(color => (
                  <ColorChooserColor key={color} color={color} onClick={this.handleSelection} />
              ))}
            </ColorChooser>
          ))}
        </div>
      </div>
    );
  }
}

export const ColorChooser: React.SFC<{}> = ({ children }) => (
  <ul className="color-chooser">
    {children}
  </ul>
)

export const ColorChooserColor: React.SFC<{ color: string, onClick?: (color: string) => void }> = ({ color, onClick }) => {
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

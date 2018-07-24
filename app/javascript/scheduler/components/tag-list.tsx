import * as React from 'react';
import { Tag } from '../store';
import { ColorPicker } from './color-picker';
import { getTextColor } from '../utils';
import { SwatchesPicker, ColorResult } from 'react-color';

interface TagListProps {
  tags: Tag[],
  onColorChange?: (id: string, color: string) => void
}

interface TagListState {
  expandedTagId: string;
}

export class TagList extends React.Component<TagListProps, TagListState>  {

  readonly state = {
    expandedTagId: ''
  }

  private handleClick = (tagId: string) => {
    this.setState({ expandedTagId: tagId })
  }

  private handleColorSelection = (id: string, color: string) => {
    const { onColorChange } = this.props;
    this.setState({ expandedTagId: '' });
    if(onColorChange) onColorChange(id, color);
  }

  render() {
    const { tags } = this.props;
    const { expandedTagId } = this.state;
    return (
      <ul style={{
        margin: 0,
        padding: 0,
        listStyle: 'none'
      }}>
        {tags.map(tag =>
          <Tag
            key={tag.id}
            tag={tag}
            expanded={tag.id == expandedTagId}
            onClick={this.handleClick}
            onColorSelection={this.handleColorSelection}
          />
        )}
      </ul>
    )
  }
}

interface TagProps {
  tag: Tag,
  expanded: boolean,
  onClick?: (id: string) => void,
  onColorSelection?: (id: string, color: string) => void
}

const Tag: React.SFC<TagProps> = ({ tag, expanded, onClick, onColorSelection }) => {

  const handleClick = () => {
    if(onClick) onClick(tag.id)
  }

  const handleColorSelection = (color: ColorResult) => {
    if(onColorSelection) onColorSelection(tag.id, color.hex)
  }

  return (
    <li
      style={{
      float: 'left',
      height: 24,
      lineHeight: '24px',
      position: 'relative',
      fontSize: 11,
      margin: '2px 5px 2px 12px',
      padding: '0 10px 0 12px',
      background: tag.color,
      color: '#fff',
      textDecoration: 'none',
      borderBottomRightRadius: 4,
      borderTopRightRadius: 4
    }}>
      <div
        onClick={handleClick}
        style={{
          cursor: 'pointer'
        }}
      >
        <div
          style={{
            float: 'left',
            position: 'absolute',
            top: 0,
            left: -12,
            width: 0,
            height: 0,
            borderColor: `transparent ${tag.color} transparent transparent`,
            borderStyle: 'solid',
            borderWidth: '12px 12px 12px 0'
          }}
        />
        <div style={{
          backgroundColor: tag.color,
          color: getTextColor(tag.color)
        }}>{tag.name}</div>
        <div style={{
          position: 'absolute',
          top: 10,
          left: 0,
          float: 'left',
          width: 4,
          height: 4,
          // mozBorderRadius: 2,
          // webkitBorderRadius: 2,
          borderRadius: 2,
          background: '#fff',
          // mozBoxShadow: '-1px -1px 2px #004977',
          // webkitBoxShadow: '-1px -1px 2px #004977',
          // boxShadow: `-1px -1px 2px #004977`
        }}/>
      </div>
      {expanded ? <SwatchesPicker color={tag.color} onChange={handleColorSelection}/> : null}
    </li>
  );
}

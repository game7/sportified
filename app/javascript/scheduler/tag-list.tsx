import * as React from 'react';
import { Tag } from './store';
import './tag-list.scss';

interface TagListProps {
 tags: Tag[]
}

export const TagList: React.SFC<TagListProps> = ({ tags }) => {
  return (
    <ul style={{
      margin: 0,
      padding: 0,
      listStyle: 'none'
    }}>
      {tags.map(tag => <Tag tag={tag}/>)}
    </ul>
  )
}

export default TagList;

function getTextColor(background: string) {
  const parts = /^#?([A-Fa-f\d]{2})([A-Fa-f\d]{2})([A-Fa-f\d]{2})/i.exec(background);
  const r = parseInt(parts[1], 16);
  const g = parseInt(parts[2], 16);
  const b = parseInt(parts[3], 16);
  const a = 1 - (0.299 * r + 0.587 * g + 0.114 * b) / 255;
  return (a < 0.5) ? '#000000' : '#ffffff';
}

const Tag: React.SFC<{ tag: Tag }> = ({ tag }) => {
  return (
    <li style={{
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
      borderTopRightRadius: 4,
      cursor: 'pointer'
    }}>
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
    </li>
  );
}

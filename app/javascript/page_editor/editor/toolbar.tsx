import * as React from 'react';
import { Spacer } from '../common';
import { ButtonGroup, DefaultButton } from '../common/buttons';

export interface Snippet {
  before?: string,
  content?: string,
  after?: string,
  newline?: boolean
}

const h1: Snippet = {
  before: '# ',
  newline: true
};
const h2: Snippet = {
  before: '## ',
  newline: true
};
const h3: Snippet = {
  before: '### ',
  newline: true
};
const bold: Snippet = {
  before: '**',
  content: 'text',
  after: '**'
};
const italic: Snippet = {
  before: '*',
  content: 'text',
  after: '*'
};
const underline: Snippet = {
  before: '_',
  content: 'text',
  after: '_'
};
const strikethrough: Snippet = {
  before: '~~',
  content: 'text',
  after: '~~'
};
const ul: Snippet = {
  before: '* ',
  newline: true
};
const ol: Snippet = {
  before: '1. ',
  newline: true
};
const table: Snippet = {
  before: [
    '|   |   |   |',
    '|---|---|---|',
    '|   |   |   |',
    '|   |   |   |',
  ].join('\n'),
  newline: true
};
const link: Snippet = {
  before: '[',
  content: 'link title',
  after: '](http://)'
};
const image: Snippet = {
  before: '![',
  content: 'image title',
  after: '](http://)'
};

interface ToolbarProps {
  onAction: (Snippet) => void;
}

export const Toolbar = (props: ToolbarProps) => {
  function action(snippet: Snippet) {
    return () => props.onAction(snippet);
  }
  return (
    <div style={{ marginBottom: 5 }} className="clearfix">
      <div>
        <ButtonGroup>
          <DefaultButton label="H1" onClick={action(h1)}/>
          <DefaultButton label="H2" onClick={action(h2)}/>
          <DefaultButton label="H3" onClick={action(h3)}/>
        </ButtonGroup>
        <Spacer/>
        <ButtonGroup>
          <DefaultButton icon="bold" onClick={action(bold)}/>
          <DefaultButton icon="italic" onClick={action(italic)}/>
          <DefaultButton icon="underline" onClick={action(underline)}/>
          <DefaultButton icon="strikethrough" onClick={action(strikethrough)}/>
        </ButtonGroup>
        <Spacer/>
        <ButtonGroup>
          <DefaultButton icon="list-ul" onClick={action(ul)}/>
          <DefaultButton icon="list-ol" onClick={action(ol)}/>
          <DefaultButton icon="table" onClick={action(table)}/>
        </ButtonGroup>
        <Spacer/>
        <ButtonGroup>
          <DefaultButton icon="link" onClick={action(link)}/>
          <DefaultButton icon="image" onClick={action(image)}/>
        </ButtonGroup>
        <Spacer/>
        <DefaultButton icon="upload" onClick={action(image)}/>
      </div>
    </div>
  );
};

export default Toolbar;

import React, { FC, useState, useEffect, CSSProperties } from 'react';
import { RouteComponentProps } from 'react-router'
import { BlockComponent, BlockPanel } from '../../components/blocks'
import { Page, Section, Block, find } from '../../actions/pages';
import { Grid, SemanticWIDTHS, Header, Container, Menu, Segment, Divider } from 'semantic-ui-react';
import { asc } from '../../utils/sort'
import { previous } from '../../utils';
import { debug } from 'util';

export const PagesEdit: FC<RouteComponentProps<{ id: number}>> = ({ match, history }) => {
  const {
    id
  } = match.params
  const [loading, setLoading] = useState(false)
  const [page, setPage] = useState<Page>()
  const [selectedBlockId, setSelectedBlockId] = useState<number>()

  const sections: Section[] = page && page.sections || []
  const blocks = sections.reduce((result, section) => {
    section.blocks.forEach(block => { result[block.id] = block })
    return result
  }, {})
  const selectedBlock = blocks[selectedBlockId]

  useEffect(() => {
    (async () => {
      setLoading(true)
      setPage(await find({ id }))
      setLoading(false)
    })()
  }, [])

  function goBack() {
    history.push(previous.location())
  }

  function moveBlock(block: Block, positions: number) {
    debugger;
    const section = sections.find(s => s.id === block.sectionId)
    const index = section.blocks.indexOf(block)
    section.blocks[index] = section.blocks[index + positions]
    section.blocks[index + positions] = block
    const p = {
      ...page,
      sections: page.sections.map(s => {
        if(s.id !== block.sectionId) { return s }
        return {
          ...s,
          blocks: section.blocks.map((b, i) => ({
            ...b,
            position: i
          }))
        }
      })
    }
    setPage(p)
  }

  function moveBlockUp(block: Block) {
    moveBlock(block, -1)
  }

  function moveBlockDown(block: Block) {
    moveBlock(block, 1)
  }

  function handleBlockChange(data: Block) {
    const updated = {
      ...data
    }
    const p = {
      ...page,
      sections: page.sections.map(section => {
        if(section.id !== data.sectionId) { return section }
        return {
          ...section,
          blocks: section.blocks.map(block => {
            if(block.id !== data.id) { return block }
            return updated
          })
        }
      })
    }
    setPage(p)
  }

  return (
    <React.Fragment>
      <Menu style={{ borderRadius: 0, margin: 0 }} fixed="top">
        <Menu.Item icon="chevron left" onClick={goBack} name="Go Back" />
      </Menu>
      <Grid>
        <Grid.Row>
          <Grid.Column width="12" textAlign="center">
            <Container textAlign="left" style={{ marginTop: 14 }}>
              {page && (
                <>
                  <Header as="h1">{page.title}</Header>
                  <Divider/>
                </>
              )}
              <Grid>
                {page && asc(page.sections, "position").map(section => (
                  <Section
                    key={section.id}
                    section={section}
                    selectedBlock={selectedBlock}
                    onBlockSelect={setSelectedBlockId}
                    onBlockMoveUp={moveBlockUp}
                    onBlockMoveDown={moveBlockDown}
                  />
                ))}
              </Grid>
            </Container>
          </Grid.Column>
          <Grid.Column width="4">
            <Menu vertical fixed="right" style={{ marginTop: 42, width: '25%' }}>
              {selectedBlock && (
                <Menu.Item>
                  <BlockPanel block={selectedBlock} onChange={handleBlockChange} />
                </Menu.Item>

              )}

            </Menu>
            {/* <Segment style={{ height: '100%' }}>
              {selectedBlock && (
                <BlockPanel block={selectedBlock} onChange={handleBlockChange} />
              )}
            </Segment> */}
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </React.Fragment>
  )
}

interface SectionProps {
  section: Section
  selectedBlock: Block
  onBlockSelect: (id: number) => void
  onBlockMoveUp: (block: Block) => void
  onBlockMoveDown: (block: Block) => void
}

const Section: FC<SectionProps> = ({ section, selectedBlock, onBlockSelect, onBlockMoveUp, onBlockMoveDown }) => {
  const columns = section.pattern.split('|')
  const blocks = section.blocks.reduce((result, block) => {
    const column = result[block.column] || [];
    result[block.column] = [...column, block];
    return result
  }, [])
  function width(w: string) {
    return Math.round(16 * (parseInt(w) / 100)).toString() as SemanticWIDTHS
  }
  return (
    <Grid.Row>
      {columns.map((col, i) => (
        <Grid.Column key={i} width={width(col)}>
          <Blocks
            blocks={blocks[i]}
            selection={selectedBlock}
            onSelect={onBlockSelect}
            onMoveUp={onBlockMoveUp}
            onMoveDown={onBlockMoveDown}
          ></Blocks>
        </Grid.Column>
      ))}
    </Grid.Row>
  )
}

interface BlocksProps {
  blocks: Block[];
  selection: Block;
  onSelect: (id: number) => void;
  onMoveUp: (block: Block) => void;
  onMoveDown: (block: Block) => void;
}

const Blocks: FC<BlocksProps> = ({ blocks, selection, onSelect, onMoveUp, onMoveDown }) => {
  const ordered = asc(blocks, "position")
  return (
    <React.Fragment>
      {asc(blocks, "position").map((block, i) => (
        <BlockComponent
          key={block.id}
          block={block}
          selected={selection && selection.id === block.id}
          isFirst={i === 0}
          isLast={i === (ordered.length - 1)}
          onClick={() => { onSelect(block.id) }}
          onMoveUp={onMoveUp}
          onMoveDown={onMoveDown}
        />
      ))}
    </React.Fragment>
  )
}



export default PagesEdit;
